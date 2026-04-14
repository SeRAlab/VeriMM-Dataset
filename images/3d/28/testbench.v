`timescale 1ns/1ps

module pcie_endpoint_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg req_read;
    reg req_write;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint dut (
        .clk(clk),
        .error(error),
        .req_read(req_read),
        .req_write(req_write),
        .rst(rst),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_read = 0;
            req_write = 0;
            error = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Power-on Reset to IDLE");
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition IDLE -> READ");
            reset_dut();
            req_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(READ);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transition IDLE -> WRITE");
            reset_dut();
            req_write = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(WRITE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: READ completion -> IDLE");
            reset_dut();
            req_read = 1;
            @(posedge clk);
            #1;
            req_read = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: WRITE completion -> IDLE");
            reset_dut();
            req_write = 1;
            @(posedge clk);
            #1;
            req_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: IDLE -> ERROR");
            reset_dut();
            error = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ERROR);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: READ -> ERROR");
            reset_dut();
            req_read = 1;
            @(posedge clk);
            #1;
            error = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ERROR);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: WRITE -> ERROR");
            reset_dut();
            req_write = 1;
            @(posedge clk);
            #1;
            error = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ERROR);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, error, req_read, req_write, rst, state);
    end

endmodule
