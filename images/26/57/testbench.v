`timescale 1ns/1ps

module nat_device_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg reset;
    wire [31:0] output_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_device dut (
        .clk(clk),
        .control(control),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .reset(reset),
        .output_ip(output_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            external_ip = 32'h0;
            internal_ip = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Control Inactive (Internal IP Selection)");

            internal_ip = 32'hC0A80001;
            external_ip = 32'h08080808;
            control = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Control Active (External IP Selection)");

            internal_ip = 32'h0A000001;
            external_ip = 32'hAC100001;
            control = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAC100001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Boundary Values - Internal 0, External All Fs, Control Active");

            internal_ip = 32'h00000000;
            external_ip = 32'hFFFFFFFF;
            control = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Boundary Values - Internal All Fs, External 0, Control Inactive");

            internal_ip = 32'hFFFFFFFF;
            external_ip = 32'h00000000;
            control = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Random IP Values - Control Active");

            internal_ip = 32'h12345678;
            external_ip = 32'hDEADBEEF;
            control = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Control Toggle Post-Reset");

            internal_ip = 32'hAABBCCDD;
            external_ip = 32'h11223344;


            control = 1'b0;
            @(posedge clk);
            #1;


            control = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_device Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_output_ip;
        begin
            if (expected_output_ip === (expected_output_ip ^ output_ip ^ expected_output_ip)) begin
                $display("PASS");
                $display("  Outputs: output_ip=%h",
                         output_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_ip=%h",
                         expected_output_ip);
                $display("  Got:      output_ip=%h",
                         output_ip);
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
        $dumpvars(0,clk, control, external_ip, internal_ip, reset, output_ip);
    end

endmodule
