`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] req;
    reg rst;
    wire [3:0] ack;
    wire [7:0] data_out;
    wire [1:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .req(req),
        .rst(rst),
        .ack(ack),
        .data_out(data_out),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            data_in = 8'h00;
            #10;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request Channel 0", test_num);
            reset_dut();
            req = 4'b0001;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001, 8'hAA, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request Channel 2", test_num);
            reset_dut();
            req = 4'b0100;
            data_in = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100, 8'h55, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round Robin - Simultaneous Requests (Check Ch 3)", test_num);
            reset_dut();
            req = 4'b1111;
            data_in = 8'h01; @(posedge clk); #1;
            data_in = 8'h02; @(posedge clk); #1;
            data_in = 8'h03; @(posedge clk); #1;
            data_in = 8'h04; @(posedge clk); #1;


            #1;



            check_outputs(4'b1000, 8'h04, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round Robin - Jumping Channels (0 then 3)", test_num);
            reset_dut();
            req = 4'b1001;
            data_in = 8'hA1; @(posedge clk); #1;
            data_in = 8'hA2; @(posedge clk); #1;

            #1;


            check_outputs(4'b1000, 8'hA2, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (No Requests)", test_num);
            reset_dut();
            req = 4'b0000;
            data_in = 8'hFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0000, 8'h00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            req = 4'b1111;
            data_in = 8'hBB;
            @(posedge clk);
            #1;
            rst = 1;
            #20;
            rst = 0;
            #1;
            #1;

            check_outputs(4'b0000, 8'h00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round Robin Wrap Around (3 then 0)", test_num);
            reset_dut();

            req = 4'b1000;
            data_in = 8'h33;
            @(posedge clk); #1;


            req = 4'b1001;
            data_in = 8'h00;
            @(posedge clk); #1;

            #1;


            check_outputs(4'b0001, 8'h00, 2'b00);
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
        input [3:0] expected_ack;
        input [7:0] expected_data_out;
        input [1:0] expected_sel;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, data_out=%h, sel=%h",
                         ack, data_out, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, data_out=%h, sel=%h",
                         expected_ack, expected_data_out, expected_sel);
                $display("  Got:      ack=%h, data_out=%h, sel=%h",
                         ack, data_out, sel);
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
        $dumpvars(0,clk, data_in, req, rst, ack, data_out, sel);
    end

endmodule
