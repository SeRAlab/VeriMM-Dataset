`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dest_addr_ch0;
    reg [15:0] dest_addr_ch1;
    reg reset;
    reg [15:0] src_addr_ch0;
    reg [15:0] src_addr_ch1;
    reg start_ch0;
    reg start_ch1;
    reg [7:0] transfer_size_ch0;
    reg [7:0] transfer_size_ch1;
    wire done_ch0;
    wire done_ch1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr_ch0(dest_addr_ch0),
        .dest_addr_ch1(dest_addr_ch1),
        .reset(reset),
        .src_addr_ch0(src_addr_ch0),
        .src_addr_ch1(src_addr_ch1),
        .start_ch0(start_ch0),
        .start_ch1(start_ch1),
        .transfer_size_ch0(transfer_size_ch0),
        .transfer_size_ch1(transfer_size_ch1),
        .done_ch0(done_ch0),
        .done_ch1(done_ch1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_ch0 = 0;
            start_ch1 = 0;
            src_addr_ch0 = 0;
            dest_addr_ch0 = 0;
            transfer_size_ch0 = 0;
            src_addr_ch1 = 0;
            dest_addr_ch1 = 0;
            transfer_size_ch1 = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Channel 0 Basic Transfer", test_num);
            reset_dut();

            src_addr_ch0 = 16'h1000;
            dest_addr_ch0 = 16'h2000;
            transfer_size_ch0 = 8'd10;

            @(posedge clk);
            start_ch0 = 1;
            @(posedge clk);
            start_ch0 = 0;


            fork
                begin
                    wait(done_ch0);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join_any

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Channel 1 Basic Transfer", test_num);
            reset_dut();

            src_addr_ch1 = 16'h3000;
            dest_addr_ch1 = 16'h4000;
            transfer_size_ch1 = 8'd5;

            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;

            fork
                begin
                    wait(done_ch1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join_any

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Parallel Channel 0 and 1 Transfer", test_num);
            reset_dut();

            src_addr_ch0 = 16'hA000;
            dest_addr_ch0 = 16'hB000;
            transfer_size_ch0 = 8'd15;

            src_addr_ch1 = 16'hC000;
            dest_addr_ch1 = 16'hD000;
            transfer_size_ch1 = 8'd15;

            @(posedge clk);
            start_ch0 = 1;
            start_ch1 = 1;
            @(posedge clk);
            start_ch0 = 0;
            start_ch1 = 0;

            fork
                begin
                    wait(done_ch0 && done_ch1);
                end
                begin
                    repeat (200) @(posedge clk);
                end
            join_any

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sequential Transfer (Ch0 then Ch1)", test_num);
            reset_dut();


            src_addr_ch0 = 16'h1111;
            dest_addr_ch0 = 16'h2222;
            transfer_size_ch0 = 8'd4;
            @(posedge clk);
            start_ch0 = 1;
            @(posedge clk);
            start_ch0 = 0;
            wait(done_ch0);


            src_addr_ch1 = 16'h3333;
            dest_addr_ch1 = 16'h4444;
            transfer_size_ch1 = 8'd4;
            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;
            wait(done_ch1);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Zero Transfer Size", test_num);
            reset_dut();

            src_addr_ch0 = 16'hFFFF;
            dest_addr_ch0 = 16'h0000;
            transfer_size_ch0 = 8'd0;

            @(posedge clk);
            start_ch0 = 1;
            @(posedge clk);
            start_ch0 = 0;



            repeat (5) @(posedge clk);



            #1;




            check_outputs(done_ch0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Maximum Transfer Size", test_num);
            reset_dut();

            src_addr_ch1 = 16'h0001;
            dest_addr_ch1 = 16'h00FF;
            transfer_size_ch1 = 8'hFF;

            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;

            fork
                begin
                    wait(done_ch1);
                end
                begin
                    repeat (1000) @(posedge clk);
                end
            join_any

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_done_ch0;
        input expected_done_ch1;
        begin
            if (expected_done_ch0 === (expected_done_ch0 ^ done_ch0 ^ expected_done_ch0) &&
                expected_done_ch1 === (expected_done_ch1 ^ done_ch1 ^ expected_done_ch1)) begin
                $display("PASS");
                $display("  Outputs: done_ch0=%b, done_ch1=%b",
                         done_ch0, done_ch1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_ch0=%b, done_ch1=%b",
                         expected_done_ch0, expected_done_ch1);
                $display("  Got:      done_ch0=%b, done_ch1=%b",
                         done_ch0, done_ch1);
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
        $dumpvars(0,clk, dest_addr_ch0, dest_addr_ch1, reset, src_addr_ch0, src_addr_ch1, start_ch0, start_ch1, transfer_size_ch0, transfer_size_ch1, done_ch0, done_ch1);
    end

endmodule
