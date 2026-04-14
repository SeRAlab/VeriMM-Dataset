`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg req;
    reg rst;
    reg [15:0] transfer_count;
    wire ack;
    wire [15:0] addr;
    wire [7:0] data_out;

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
        .transfer_count(transfer_count),
        .ack(ack),
        .addr(addr),
        .data_out(data_out)
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
            data_in = 8'h00;
            transfer_count = 16'h0000;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single-byte transfer", test_num);
            reset_dut();


            transfer_count = 16'd1;
            data_in = 8'hA5;
            req = 1;



            repeat (2) @(posedge clk);
            req = 0;
            repeat (1) @(posedge clk);


            #1;



            check_outputs(1'b0, 16'd1, 8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multi-byte transfer (8 bytes)", test_num);
            reset_dut();

            transfer_count = 16'd8;
            req = 1;


            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
            end

            req = 0;
            repeat (1) @(posedge clk);


            #1;



            check_outputs(1'b0, 16'd8, 8'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero-count transfer request", test_num);
            reset_dut();

            transfer_count = 16'd0;
            data_in = 8'hFF;
            req = 1;

            repeat (2) @(posedge clk);
            req = 0;
            repeat (1) @(posedge clk);


            #1;



            check_outputs(1'b0, 16'd0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Successive transfers", test_num);
            reset_dut();


            transfer_count = 16'd2;
            req = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            req = 0;
            repeat (2) @(posedge clk);


            transfer_count = 16'd1;
            req = 1;
            data_in = 8'h33; @(posedge clk);
            req = 0;
            repeat (1) @(posedge clk);





            #1;






            check_outputs(1'b0, 16'd3, 8'h33);
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
        input expected_ack;
        input [15:0] expected_addr;
        input [7:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, addr=%h, data_out=%h",
                         ack, addr, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, addr=%h, data_out=%h",
                         expected_ack, expected_addr, expected_data_out);
                $display("  Got:      ack=%b, addr=%h, data_out=%h",
                         ack, addr, data_out);
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
        $dumpvars(0,clk, data_in, req, rst, transfer_count, ack, addr, data_out);
    end

endmodule
