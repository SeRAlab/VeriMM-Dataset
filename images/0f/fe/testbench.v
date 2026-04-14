`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg done;
    reg read_cmd;
    reg rst;
    reg start;
    reg write_cmd;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .done(done),
        .read_cmd(read_cmd),
        .rst(rst),
        .start(start),
        .write_cmd(write_cmd),
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
            start = 0;
            read_cmd = 0;
            write_cmd = 0;
            done = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset to IDLE", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: IDLE to READ Transition", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            read_cmd = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: IDLE to WRITE Transition", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            write_cmd = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: READ to IDLE on Done", test_num);
            reset_dut();

            @(posedge clk);
            start = 1; read_cmd = 1;
            @(posedge clk);

            #1 start = 0; read_cmd = 0; done = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: WRITE to IDLE on Done", test_num);
            reset_dut();

            @(posedge clk);
            start = 1; write_cmd = 1;
            @(posedge clk);

            #1 start = 0; write_cmd = 0; done = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Stay in READ if not done", test_num);
            reset_dut();
            @(posedge clk);
            start = 1; read_cmd = 1;
            @(posedge clk);
            #1 start = 0; read_cmd = 0; done = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: No transition if start is low", test_num);
            reset_dut();
            @(posedge clk);
            start = 0; read_cmd = 1; write_cmd = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: READ sequence followed by WRITE", test_num);
            reset_dut();

            @(posedge clk);
            start = 1; read_cmd = 1;
            @(posedge clk);
            #1 start = 0; read_cmd = 0; done = 1;
            @(posedge clk);

            #1 done = 0; start = 1; write_cmd = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        $dumpvars(0,clk, done, read_cmd, rst, start, write_cmd, state);
    end

endmodule
