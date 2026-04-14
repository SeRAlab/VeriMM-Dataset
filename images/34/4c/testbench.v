`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req;
    reg rst;
    reg rw;
    wire done;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .rw(rw),
        .done(done),
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
        req = 0;
        rw = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Initial Reset to IDLE", test_num);
        reset_dut();

        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: IDLE to READ Transition", test_num);
        reset_dut();
        @(posedge clk);
        req = 1;
        rw = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, READ);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: READ back to IDLE Transition", test_num);
        reset_dut();
        @(posedge clk);
        req = 1;
        rw = 1;
        @(posedge clk);
        #1 req = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: IDLE to WRITE Transition", test_num);
        reset_dut();
        @(posedge clk);
        req = 1;
        rw = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, WRITE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: WRITE back to IDLE Transition", test_num);
        reset_dut();
        @(posedge clk);
        req = 1;
        rw = 0;
        @(posedge clk);
        #1 req = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Reset during READ operation", test_num);
        reset_dut();
        @(posedge clk);
        req = 1;
        rw = 1;
        @(posedge clk);
        #1 rst = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Verify no state change if req=0", test_num);
        reset_dut();
        rw = 1;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_done;
        input [1:0] expected_state;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: done=%b, state=%h",
                         done, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, state=%h",
                         expected_done, expected_state);
                $display("  Got:      done=%b, state=%h",
                         done, state);
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
        $dumpvars(0,clk, req, rst, rw, done, state);
    end

endmodule
