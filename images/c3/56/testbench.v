`timescale 1ns/1ps

module POR_tb;

    // Testbench signals (sequential circuit)
    reg VDD;
    wire RST;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    POR dut (
        .VDD(VDD),
        .RST(RST)
    );

    // Clock generation (10ns period)
    initial begin
        VDD = 0;
        forever #5 VDD = ~VDD;
    end

        task reset_dut;

        begin
            $display("Status: Simulating Power Cycle (Power-Off then Power-On)...");
            force VDD = 0;
            #50;
            release VDD;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial Assertion Check", test_num);
            reset_dut();



            #30;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: De-assertion Timing Check", test_num);
            reset_dut();



            #150;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Long-term Stability Check", test_num);
            reset_dut();


            #500;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary Condition Check", test_num);
            reset_dut();



            #95;


            #1;



            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("POR Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_RST;
        begin
            if (expected_RST === (expected_RST ^ RST ^ expected_RST)) begin
                $display("PASS");
                $display("  Outputs: RST=%b",
                         RST);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RST=%b",
                         expected_RST);
                $display("  Got:      RST=%b",
                         RST);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,VDD, RST);
    end

endmodule
