`timescale 1ns/1ps

module DRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg WL;
    wire BL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DRAM_Cell dut (
        .D(D),
        .WL(WL),
        .BL(BL)
    );

    // Clock generation (10ns period)
    initial begin
        WL = 0;
        forever #5 WL = ~WL;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            D = 0;

            @(posedge WL);
            #2;
            D = 0;

            @(negedge WL);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Store '1' and Read '1'", test_num);


            @(posedge WL);
            D = 1;


            @(negedge WL);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Store '0' and Read '0'", test_num);


            @(posedge WL);
            D = 0;


            @(negedge WL);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Overwrite '1' with '0'", test_num);


            @(posedge WL);
            D = 1;
            @(negedge WL);


            @(posedge WL);
            D = 0;


            @(negedge WL);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Data persistence when WL is low", test_num);


            @(posedge WL);
            D = 1;


            @(negedge WL);
            #1;
            D = 0;
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Data persistence over multiple WL cycles", test_num);


            @(posedge WL);
            D = 1;
            @(negedge WL);


            @(posedge WL);
            D = 1;
            @(negedge WL);


            #2;
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
        $display("DRAM_Cell Testbench");
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
        begin
            if (expected_BL === (expected_BL ^ BL ^ expected_BL)) begin
                $display("PASS");
                $display("  Outputs: BL=%b",
                         BL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BL=%b",
                         expected_BL);
                $display("  Got:      BL=%b",
                         BL);
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
        $dumpvars(0,D, WL, BL);
    end

endmodule
