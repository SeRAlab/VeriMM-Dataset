`timescale 1ns/1ps

module nvme_command_queue_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd_complete;
    reg [31:0] cmd_in;
    reg cmd_valid;
    reg rst_n;
    wire [31:0] cmd_out;
    wire cmd_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_queue_manager dut (
        .clk(clk),
        .cmd_complete(cmd_complete),
        .cmd_in(cmd_in),
        .cmd_valid(cmd_valid),
        .rst_n(rst_n),
        .cmd_out(cmd_out),
        .cmd_ready(cmd_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            cmd_complete = 0;
            cmd_in = 0;
            cmd_valid = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Command Push", test_num);
            reset_dut();
            @(posedge clk);
            cmd_in = 32'hDEADBEEF;
            cmd_valid = 1;
            @(posedge clk);
            cmd_valid = 0;
            @(posedge clk);

            #1;


            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multi-Push and Single Pop", test_num);
            reset_dut();

            @(posedge clk);
            cmd_in = 32'h11111111; cmd_valid = 1;
            @(posedge clk);

            cmd_in = 32'h22222222;
            @(posedge clk);
            cmd_valid = 0;

            cmd_complete = 1;
            @(posedge clk);
            cmd_complete = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h22222222, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill Queue to Capacity", test_num);
            reset_dut();
            @(posedge clk);
            for (i = 1; i <= 8; i = i + 1) begin
                cmd_in = i;
                cmd_valid = 1;
                @(posedge clk);
            end
            cmd_valid = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h00000001, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Emptying Full Queue", test_num);
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                cmd_in = i; cmd_valid = 1;
            end
            @(posedge clk);
            cmd_valid = 0;

            for (i = 1; i <= 8; i = i + 1) begin
                cmd_complete = 1;
                @(posedge clk);
            end
            cmd_complete = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Interleaved Push/Pop", test_num);
            reset_dut();

            @(posedge clk);
            cmd_in = 32'hAAAA_AAAA; cmd_valid = 1;
            @(posedge clk);

            cmd_in = 32'hBBBB_BBBB;
            @(posedge clk);
            cmd_valid = 0;

            cmd_complete = 1;
            @(posedge clk);
            cmd_complete = 0;

            cmd_in = 32'hCCCC_CCCC; cmd_valid = 1;
            @(posedge clk);
            cmd_valid = 0;
            @(posedge clk);

            #1;


            check_outputs(32'hBBBB_BBBB, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("\nTestcase %0d: Overflow Handling Check", test_num);
            reset_dut();

            for (i = 1; i <= 10; i = i + 1) begin
                @(posedge clk);
                cmd_in = i; cmd_valid = 1;
            end
            @(posedge clk);
            cmd_valid = 0;

            for (i = 1; i <= 7; i = i + 1) begin
                cmd_complete = 1;
                @(posedge clk);
            end
            cmd_complete = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h00000008, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_queue_manager Testbench");
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
        input [31:0] expected_cmd_out;
        input expected_cmd_ready;
        begin
            if (expected_cmd_out === (expected_cmd_out ^ cmd_out ^ expected_cmd_out) &&
                expected_cmd_ready === (expected_cmd_ready ^ cmd_ready ^ expected_cmd_ready)) begin
                $display("PASS");
                $display("  Outputs: cmd_out=%h, cmd_ready=%b",
                         cmd_out, cmd_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_out=%h, cmd_ready=%b",
                         expected_cmd_out, expected_cmd_ready);
                $display("  Got:      cmd_out=%h, cmd_ready=%b",
                         cmd_out, cmd_ready);
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
        $dumpvars(0,clk, cmd_complete, cmd_in, cmd_valid, rst_n, cmd_out, cmd_ready);
    end

endmodule
