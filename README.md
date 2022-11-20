# ElementIo

This repository contains a solution for the take home test at Element.io

## Task description:
```
We have a set of tasks, each running at least daily, which are scheduled with a simplified cron. We want to find when each of them will next run.

An example scheduler config looks like this:

30 1 /bin/run_me_daily
45 * /bin/run_me_hourly
* * /bin/run_me_every_minute
* 19 /bin/run_me_sixty_times

The first field is the minutes past the hour, the second field is the hour of the day and the third is the command to run. For both cases * means that it should run for all values of that field. In the above example run_me_daily has been set to run at 1:30am every day and run_me_hourly at 45 minutes past the hour every hour. The fields are whitespace separated and each entry is on a separate line.

When the task should fire at the simulated 'current time' then that is the time you should output, not the next one.

For example given the above examples as input and the simulated 'current time' command-line argument 16:10 the output should be

1:30 tomorrow - /bin/run_me_daily
16:45 today - /bin/run_me_hourly
16:10 today - /bin/run_me_every_minute
19:00 today - /bin/run_me_sixty_times
```

## How to run
You can run the task from the source code by running the following command from the root directory:

```
cat example_input.txt | swift run ElementIo 16:10
```

Alternatively, you can use the pre-compiled binary:
```
cat example_input.txt | CronParser 16:10
```

## Notes for the reviewers
There is a couple of things I would've done differently if I had an opportunity to discuss the task:

* The current script doesn't produce any output for invalid input. It would've been more helpful if the script printed descriptive errors indicating what is wrong with the input. However, I was worried that it'd break the automation test suite that you have, so I didn't do it.
* It's not very clear how to handle a single digit in the input. I.e. `30 1` is printed as `1:30`, while `* 19` is printed as `19:00`. Personally, I would've appended a leading zero to a single digit in the output (`01:30`, `19:00`) and I would've prohibitted a single digit in the input. However, I decided to leave it relaxed and output a single digit as well. Not sure if this is what's expected.  
