`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request;
    reg rst;
    reg [7:0] transfer_count;
    wire [7:0] current_transfer_count;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request(request),
        .rst(rst),
        .transfer_count(transfer_count),
        .current_transfer_count(current_transfer_count),
        .transfer_done(transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            request = 0;
            transfer_count = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Transfer (Count=5)", test_num);
            reset_dut();

            transfer_count = 8'd5;
            request = 1;


            repeat (6) @(posedge clk);

            request = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimal Transfer (Count=1)", test_num);
            reset_dut();

            transfer_count = 8'd1;
            request = 1;

            repeat (2) @(posedge clk);

            request = 0;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Transfer (Count=20)", test_num);
            reset_dut();

            transfer_count = 8'd20;
            request = 1;

            repeat (21) @(posedge clk);

            request = 0;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-Transfer", test_num);
            reset_dut();

            transfer_count = 8'd10;
            request = 1;

            repeat (5) @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();

            transfer_count = 8'd10;
            request = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_current_transfer_count;
        input expected_transfer_done;
        begin
            if (expected_current_transfer_count === (expected_current_transfer_count ^ current_transfer_count ^ expected_current_transfer_count) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: current_transfer_count=%h, transfer_done=%b",
                         current_transfer_count, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_transfer_count=%h, transfer_done=%b",
                         expected_current_transfer_count, expected_transfer_done);
                $display("  Got:      current_transfer_count=%h, transfer_done=%b",
                         current_transfer_count, transfer_done);
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
        $dumpvars(0,clk, request, rst, transfer_count, current_transfer_count, transfer_done);
    end

endmodule
