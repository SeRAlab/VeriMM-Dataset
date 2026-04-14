`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg config_req;
    reg data_req;
    reg reset;
    wire [1:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .config_req(config_req),
        .data_req(data_req),
        .reset(reset),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            config_req = 0;
            data_req = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Check IDLE state after Reset");
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Transition IDLE to CONFIG");
            reset_dut();
            config_req = 1;
            @(posedge clk);
            #1 config_req = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Transition CONFIG to DATA");
            reset_dut();

            config_req = 1;
            @(posedge clk);
            #1 config_req = 0;

            data_req = 1;
            @(posedge clk);
            #1 data_req = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Persistence in DATA state");
            reset_dut();

            config_req = 1;
            @(posedge clk);
            #1 config_req = 0;

            data_req = 1;
            @(posedge clk);
            #1 data_req = 0;

            data_req = 1;
            @(posedge clk);
            #1 data_req = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Reset from CONFIG state back to IDLE");
            reset_dut();
            config_req = 1;
            @(posedge clk);
            #1 config_req = 0;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Reset from DATA state back to IDLE");
            reset_dut();
            config_req = 1; @(posedge clk); #1 config_req = 0;
            data_req = 1;   @(posedge clk); #1 data_req = 0;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Ignore DATA_REQ while in IDLE");
            reset_dut();
            data_req = 1;
            @(posedge clk);
            #1 data_req = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Ignore CONFIG_REQ while in DATA");
            reset_dut();
            config_req = 1; @(posedge clk); #1 config_req = 0;
            data_req = 1;   @(posedge clk); #1 data_req = 0;

            config_req = 1;
            @(posedge clk);
            #1 config_req = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, config_req, data_req, reset, state_out);
    end

endmodule
