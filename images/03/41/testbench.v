`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req1;
    reg req2;
    reg rst_n;
    reg [7:0] src1;
    reg [7:0] src2;
    wire ack1;
    wire ack2;
    wire [7:0] data_out;
    wire [7:0] dst1;
    wire [7:0] dst2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req1(req1),
        .req2(req2),
        .rst_n(rst_n),
        .src1(src1),
        .src2(src2),
        .ack1(ack1),
        .ack2(ack2),
        .data_out(data_out),
        .dst1(dst1),
        .dst2(dst2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req1 = 0;
            req2 = 0;
            src1 = 0;
            src2 = 0;
            repeat (2) @(posedge clk);
            #1 rst_n = 1;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Single Transfer", test_num);
            reset_dut();

            src1 = 8'hA5;
            req1 = 1;


            wait(ack1 == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 8'hA5, 8'hA5, 8'h00);

            req1 = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Single Transfer", test_num);
            reset_dut();

            src2 = 8'h5A;
            req2 = 1;


            wait(ack2 == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 8'h5A, 8'h00, 8'h5A);

            req2 = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Request - Channel 1 then 2", test_num);
            reset_dut();

            src1 = 8'h11;
            src2 = 8'h22;
            req1 = 1;
            req2 = 1;


            wait(ack1 == 1);
            @(posedge clk);
            req1 = 0;


            wait(ack2 == 1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 1'b1, 8'h22, 8'h11, 8'h22);

            req2 = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential back-to-back requests", test_num);
            reset_dut();


            src2 = 8'hAA;
            req2 = 1;
            wait(ack2 == 1);
            @(posedge clk);
            req2 = 0;
            @(posedge clk);


            src1 = 8'hBB;
            req1 = 1;
            wait(ack1 == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 8'hBB, 8'hBB, 8'hAA);

            req1 = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid Request Toggle", test_num);
            reset_dut();

            src1 = 8'hCC;
            src2 = 8'hDD;


            req1 = 1;
            wait(ack1 == 1);
            @(posedge clk);


            req2 = 1;
            @(posedge clk);
            req1 = 0;


            wait(ack2 == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 8'hDD, 8'hCC, 8'hDD);

            req2 = 0;
            @(posedge clk);
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
        input expected_ack1;
        input expected_ack2;
        input [7:0] expected_data_out;
        input [7:0] expected_dst1;
        input [7:0] expected_dst2;
        begin
            if (expected_ack1 === (expected_ack1 ^ ack1 ^ expected_ack1) &&
                expected_ack2 === (expected_ack2 ^ ack2 ^ expected_ack2) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_dst1 === (expected_dst1 ^ dst1 ^ expected_dst1) &&
                expected_dst2 === (expected_dst2 ^ dst2 ^ expected_dst2)) begin
                $display("PASS");
                $display("  Outputs: ack1=%b, ack2=%b, data_out=%h, dst1=%h, dst2=%h",
                         ack1, ack2, data_out, dst1, dst2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack1=%b, ack2=%b, data_out=%h, dst1=%h, dst2=%h",
                         expected_ack1, expected_ack2, expected_data_out, expected_dst1, expected_dst2);
                $display("  Got:      ack1=%b, ack2=%b, data_out=%h, dst1=%h, dst2=%h",
                         ack1, ack2, data_out, dst1, dst2);
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
        $dumpvars(0,clk, req1, req2, rst_n, src1, src2, ack1, ack2, data_out, dst1, dst2);
    end

endmodule
