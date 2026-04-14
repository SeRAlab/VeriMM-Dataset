`timescale 1ns/1ps

module SRAM16bit_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM16bit dut (
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        we = 0;
        forever #5 we = ~we;
    end

        task reset_dut;

        begin
            $display("Resetting SRAM...");
            data_in = 16'h0000;

            @(posedge we);

            @(negedge we);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xAAAA)", test_num);

            data_in = 16'hAAAA;
            @(posedge we);
            @(negedge we);
            #2;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Retention (Input changes while we=0)", test_num);


            data_in = 16'h5555;
            @(posedge we);
            @(negedge we);


            data_in = 16'hFFFF;
            #2;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (0xFFFF and 0x0000)", test_num);


            data_in = 16'hFFFF;
            @(posedge we);
            @(negedge we);
            #1;


            data_in = 16'h0000;
            @(posedge we);
            @(negedge we);
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Overwrites", test_num);


            data_in = 16'h1234;
            @(posedge we);
            @(negedge we);


            data_in = 16'hBEEF;
            @(posedge we);
            @(negedge we);
            #2;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Random Pattern (0x1357)", test_num);

            data_in = 16'h1357;
            @(posedge we);
            @(negedge we);
            #2;

            #1;


            check_outputs(16'h1357);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, we, data_out);
    end

endmodule
