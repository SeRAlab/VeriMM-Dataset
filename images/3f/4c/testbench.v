`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] cmd;
    reg rst;
    wire [1:0] state;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .cmd(cmd),
        .rst(rst),
        .state(state),
        .success(success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cmd = IDLE;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(IDLE, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            cmd = READ;
            @(posedge clk);
            #1;
            #1;

            check_outputs(READ, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            cmd = WRITE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(WRITE, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            cmd = ERROR;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ERROR, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            cmd = READ;
            @(posedge clk);
            #1;
            cmd = WRITE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(WRITE, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            cmd = WRITE;
            @(posedge clk);
            #1;
            cmd = ERROR;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ERROR, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            cmd = ERROR;
            @(posedge clk);
            #1;
            cmd = IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input [1:0] expected_state;
        input expected_success;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: state=%h, success=%b",
                         state, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, success=%b",
                         expected_state, expected_success);
                $display("  Got:      state=%h, success=%b",
                         state, success);
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
        $dumpvars(0,clk, cmd, rst, state, success);
    end

endmodule
