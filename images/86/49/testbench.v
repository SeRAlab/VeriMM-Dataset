`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] Address;
    reg RClock;
    reg RWSelect;
    reg WClock;
    reg _Enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .RClock(RClock),
        .RWSelect(RWSelect),
        .WClock(WClock),
        ._Enable(_Enable)
    );

    // Clock generation (10ns period)
    initial begin
        RClock = 0;
        forever #5 RClock = ~RClock;
    end

        task reset_dut;

        begin
            _Enable = 1;
            RWSelect = 0;
            Address = 0;
            Data_reg = 0;
            drive_data = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            _Enable = 0;
            RWSelect = 0;
            Address = 11'h010;
            Data_reg = 8'hAA;
            drive_data = 1;
            #10;


            drive_data = 0;
            RWSelect = 1;
            #10;

            expected_data = 8'hAA;
            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            _Enable = 0;
            RWSelect = 0;
            Address = 11'h7FF;
            Data_reg = 8'h55;
            drive_data = 1;
            #10;

            drive_data = 0;
            RWSelect = 1;
            #10;

            expected_data = 8'h55;
            $display("Testcase 002: Memory Boundary Check");
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            _Enable = 1;
            RWSelect = 1;
            Address = 11'h010;
            #10;

            expected_data = 8'hzz;
            $display("Testcase 003: Enable (Active Low) Verification");
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            _Enable = 1;
            RWSelect = 0;
            Address = 11'h020;
            Data_reg = 8'hFF;
            drive_data = 1;
            #10;


            drive_data = 0;
            _Enable = 0;
            RWSelect = 1;
            #10;


            if (Data !== 8'hFF) begin
                pass_count = pass_count + 1;
                $display("PASS: Testcase 004: Write Protection when Disabled");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Testcase 004: Data was written despite _Enable=1");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,Address, RClock, RWSelect, WClock, _Enable);
    end

endmodule
