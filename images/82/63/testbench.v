`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg hdmi_clk;
    reg [15:0] hdmi_data;
    reg hdmi_de;
    reg hdmi_sof;
    wire hdmi_tpm_oos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hdmi_clk(hdmi_clk),
        .hdmi_data(hdmi_data),
        .hdmi_de(hdmi_de),
        .hdmi_sof(hdmi_sof),
        .hdmi_tpm_oos(hdmi_tpm_oos)
    );

    // Clock generation (10ns period)
    initial begin
        hdmi_clk = 0;
        forever #5 hdmi_clk = ~hdmi_clk;
    end

        task reset_dut;

        begin
            @(posedge hdmi_clk);
            hdmi_sof = 1;
            hdmi_de = 0;
            hdmi_data = 16'h0000;
            @(posedge hdmi_clk);
            hdmi_sof = 0;
            @(posedge hdmi_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Normal Operation", test_num);
            reset_dut();

            hdmi_de = 1;
            hdmi_data = 16'h8000;
            repeat(10) @(posedge hdmi_clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Out of Bounds High", test_num);
            reset_dut();

            hdmi_de = 1;
            hdmi_data = 16'hFFFF;
            @(posedge hdmi_clk);


            @(posedge hdmi_clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Out of Bounds Low", test_num);
            reset_dut();

            hdmi_de = 1;
            hdmi_data = 16'h0000;
            @(posedge hdmi_clk);

            @(posedge hdmi_clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Enable Gating", test_num);
            reset_dut();

            hdmi_de = 0;
            hdmi_data = 16'hFFFF;
            repeat(5) @(posedge hdmi_clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sticky Bit and SOF Reset", test_num);
            reset_dut();


            hdmi_de = 1;
            hdmi_data = 16'hFFFF;
            @(posedge hdmi_clk);


            hdmi_data = 16'h8000;
            repeat(5) @(posedge hdmi_clk);


            if (hdmi_tpm_oos === 1'b1) begin

                hdmi_sof = 1;
                @(posedge hdmi_clk);
                hdmi_sof = 0;
                hdmi_data = 16'h8000;
                @(posedge hdmi_clk);
                #1;

                check_outputs(1'b0);
            end else begin
                $display("FAIL: OOS was not sticky or did not trigger");
                fail_count = fail_count + 1;
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
        input expected_hdmi_tpm_oos;
        begin
            if (expected_hdmi_tpm_oos === (expected_hdmi_tpm_oos ^ hdmi_tpm_oos ^ expected_hdmi_tpm_oos)) begin
                $display("PASS");
                $display("  Outputs: hdmi_tpm_oos=%b",
                         hdmi_tpm_oos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hdmi_tpm_oos=%b",
                         expected_hdmi_tpm_oos);
                $display("  Got:      hdmi_tpm_oos=%b",
                         hdmi_tpm_oos);
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
        $dumpvars(0,hdmi_clk, hdmi_data, hdmi_de, hdmi_sof, hdmi_tpm_oos);
    end

endmodule
