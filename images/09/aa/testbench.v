`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg WL;
    wire BL;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .D(D),
        .WL(WL),
        .BL(BL),
        .Q(Q)
    );
    task testcase001;



        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 1 and Read 1", test_num);


            D = 1;
            WL = 1;
            #10;


            WL = 0;
            D = 0;
            #10;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;



        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 0 and Read 0", test_num);


            D = 0;
            WL = 1;
            #10;


            WL = 0;
            D = 1;
            #10;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;



        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Hold Check (WL=0, Toggle D)", test_num);


            D = 1;
            WL = 1;
            #10;


            WL = 0;
            #5;


            D = 0; #5;
            D = 1; #5;
            D = 0; #5;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;



        begin
            test_num = test_num + 1;
            $display("Test %0d: Successive Writes (1 -> 0 -> 1)", test_num);


            D = 1; WL = 1; #10;

            D = 0; WL = 1; #10;

            D = 1; WL = 1; #10;


            WL = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;



        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify BL logic during Read", test_num);


            D = 0; WL = 1; #10;


            WL = 0;
            #10;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_BL;
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BL === (expected_BL ^ BL ^ expected_BL) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: BL=%b, Q=%b",
                         BL, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BL=%b, Q=%b",
                         expected_BL, expected_Q);
                $display("  Got:      BL=%b, Q=%b",
                         BL, Q);
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
