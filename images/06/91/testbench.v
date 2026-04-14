`timescale 1ns/1ps

module min_heap_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    reg [3:0] value;
    wire [3:0] min_value;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    min_heap dut (
        .clk(clk),
        .control(control),
        .value(value),
        .min_value(min_value),
        .success(success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = CMD_IDLE;
            value = 4'h0;
            @(posedge clk);


            repeat(16) begin
                control = CMD_DELETE;
                @(posedge clk);
            end
            control = CMD_IDLE;
            @(posedge clk);
            $display("\nStarting Testcase %0d...", test_num + 1);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            control = CMD_INSERT; value = 4'd5; @(posedge clk);

            control = CMD_GET; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            control = CMD_INSERT; value = 4'd10; @(posedge clk);
            control = CMD_INSERT; value = 4'd3;  @(posedge clk);
            control = CMD_GET; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            control = CMD_INSERT; value = 4'd8; @(posedge clk);
            control = CMD_INSERT; value = 4'd4; @(posedge clk);
            control = CMD_INSERT; value = 4'd12; @(posedge clk);

            control = CMD_DELETE; @(posedge clk);

            control = CMD_GET; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            control = CMD_INSERT; value = 4'd7; @(posedge clk);
            control = CMD_INSERT; value = 4'd1; @(posedge clk);
            control = CMD_INSERT; value = 4'd9; @(posedge clk);
            control = CMD_INSERT; value = 4'd2; @(posedge clk);
            control = CMD_DELETE; @(posedge clk);
            control = CMD_DELETE; @(posedge clk);
            control = CMD_GET; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            control = CMD_INSERT;
            for (i = 0; i < 16; i = i + 1) begin
                value = i[3:0];
                @(posedge clk);
            end

            value = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(min_value, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            control = CMD_DELETE; @(posedge clk);
            #1;
            #1;

            check_outputs(min_value, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            control = CMD_INSERT; value = 4'd5; @(posedge clk);
            control = CMD_INSERT; value = 4'd2; @(posedge clk);
            control = CMD_INSERT; value = 4'd2; @(posedge clk);
            control = CMD_DELETE; @(posedge clk);
            control = CMD_GET; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("min_heap Testbench");
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
        input [3:0] expected_min_value;
        input expected_success;
        begin
            if (expected_min_value === (expected_min_value ^ min_value ^ expected_min_value) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: min_value=%h, success=%b",
                         min_value, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_value=%h, success=%b",
                         expected_min_value, expected_success);
                $display("  Got:      min_value=%h, success=%b",
                         min_value, success);
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
        $dumpvars(0,clk, control, value, min_value, success);
    end

endmodule
