/* for testing rolling_beta and fm */
discard

/* {{{ data */

webuse grunfeld, clear
/* expand 1000, generate(new) */
/* bysort company time (new) : generate newsum = sum(new) */
/* egen newcompany = group(newsum company) */
/* xtset newcompany year */

/* }}} */

/* {{{ rolling beta benchmarks */

/* timer clear */

/* preserve */
/* timer on 1 */
/* rolling _b, clear window(5) nodots : regress mvalue kstock */
/* timer off 1 */
/* list in 1/20 */
/* restore */

/* preserve */
/* timer on 2 */
/* rolling_beta2 mvalue kstock, window(5) */
/* timer off 2 */
/* list in 1/20 */
/* restore */

/* preserve */
/* timer on 3 */
/* rolling_beta mvalue kstock, long(5) short(5) */
/* timer off 3 */
/* list in 1/20 */
/* restore */

/* preserve */
/* timer on 4 */
/* rolling_beta mvalue kstock, long(5) faster */
/* timer off 4 */
/* list in 1/20 */
/* restore */

/* timer list */

/* /1* timer list *1/ */
/* /1*  1:   1094.44 /        1 =    1094.4420 *1/ */
/* /1*  2:      0.14 /        1 =       0.1410 *1/ */
/* /1*  3:      0.11 /        1 =       0.1130 *1/ */
/* /1*  4:      0.17 /        1 =       0.1730 *1/ */

/* }}} */

/* {{{ Fama-MacBeth benchmarks */

timer clear
eststo clear

/* my code */
timer on 1
fm mvalue kstock invest, estimator(regress) lags(4)
eststo
timer off 1

/* xtfmb (ssc install xtfmb) */
timer on 2
xtfmb mvalue kstock invest, lag(4)
eststo
timer off 2

/* manually */
timer on 3
preserve
statsby _b e(N) e(r2), clear by(year) : regress mvalue kstock invest
tabstat *, stat(mean semean)
restore
timer off 3

timer list
esttab

/* }}} */

