`timescale 1ns/1ps

module move_cell_tb;

    // Testbench signals (combinational circuit)
    reg b;
    reg bw_in;
    reg fw_in;
    reg pulse;
    reg r;
    wire b_out;
    wire bw_out;
    wire fw_out;
    wire r_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    move_cell dut (
        .b(b),
        .bw_in(bw_in),
        .fw_in(fw_in),
        .pulse(pulse),
        .r(r),
        .b_out(b_out),
        .bw_out(bw_out),
        .fw_out(fw_out),
        .r_out(r_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs zero (Idle)", test_num);
            r = 0; b = 0; fw_in = 0; bw_in = 0; pulse = 0;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pass-through r and b", test_num);
            r = 1; b = 0; fw_in = 0; bw_in = 0; pulse = 0;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pass-through r and b alternate", test_num);
            r = 0; b = 1; fw_in = 0; bw_in = 0; pulse = 0;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Forward movement via pulse", test_num);
            r = 0; b = 0; fw_in = 0; bw_in = 0; pulse = 1;

            #1;


            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Forward movement via r & fw_in", test_num);
            r = 1; b = 0; fw_in = 1; bw_in = 0; pulse = 0;




            #1;





            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Backward movement via bw_in", test_num);
            r = 0; b = 0; fw_in = 0; bw_in = 1; pulse = 0;




            #1;





            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Backward movement via b & fw_in", test_num);
            r = 0; b = 1; fw_in = 1; bw_in = 0; pulse = 0;




            #1;





            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Override logic (bw_in & fw_in)", test_num);
            r = 1; b = 0; fw_in = 1; bw_in = 1; pulse = 0;





            #1;






            check_outputs(1, 1, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complex state (pulse and override)", test_num);
            r = 0; b = 0; fw_in = 1; bw_in = 1; pulse = 1;



            #1;




            check_outputs(1, 1, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only r high, no motion inputs", test_num);
            r = 1; b = 0; fw_in = 0; bw_in = 0; pulse = 0;


            #1;



            check_outputs(0, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("move_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_b_out;
        input expected_bw_out;
        input expected_fw_out;
        input expected_r_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_bw_out === (expected_bw_out ^ bw_out ^ expected_bw_out) &&
                expected_fw_out === (expected_fw_out ^ fw_out ^ expected_fw_out) &&
                expected_r_out === (expected_r_out ^ r_out ^ expected_r_out)) begin
                $display("PASS");
                $display("  Outputs: b_out=%b, bw_out=%b, fw_out=%b, r_out=%b",
                         b_out, bw_out, fw_out, r_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%b, bw_out=%b, fw_out=%b, r_out=%b",
                         expected_b_out, expected_bw_out, expected_fw_out, expected_r_out);
                $display("  Got:      b_out=%b, bw_out=%b, fw_out=%b, r_out=%b",
                         b_out, bw_out, fw_out, r_out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
