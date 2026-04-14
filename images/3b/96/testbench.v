`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_read;
    reg req_write;
    reg reset;
    wire busy;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .req_read(req_read),
        .req_write(req_write),
        .reset(reset),
        .busy(busy),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req_read = 0;
            req_write = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Reset to IDLE", test_num);

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Transition to READ", test_num);
            req_read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Transition to WRITE", test_num);
            req_write = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Conflict to ERROR", test_num);
            req_read = 1;
            req_write = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Return to IDLE", test_num);

            req_read = 1;
            @(posedge clk);
            #1;

            req_read = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase %0d: Reset during operation", test_num);
            req_write = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0, 2'b00);
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
        input expected_busy;
        input [1:0] expected_state;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, state=%h",
                         busy, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, state=%h",
                         expected_busy, expected_state);
                $display("  Got:      busy=%b, state=%h",
                         busy, state);
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
        $dumpvars(0,clk, req_read, req_write, reset, busy, state);
    end

endmodule
