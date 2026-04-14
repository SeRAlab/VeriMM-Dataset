`timescale 1ns/1ps

module pcie_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [3:0] pkt_length;
    reg rst_n;
    reg start;
    wire busy;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_tx dut (
        .clk(clk),
        .data_in(data_in),
        .pkt_length(pkt_length),
        .rst_n(rst_n),
        .start(start),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start = 0;
            data_in = 0;
            pkt_length = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Single Word Packet (Length 1)", test_num);
            reset_dut();

            data_in = 32'hDEADBEEF;
            pkt_length = 4'd1;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multi-Word Packet (Length 4)", test_num);
            reset_dut();

            pkt_length = 4'd4;
            data_in = 32'h11111111;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            data_in = 32'h22222222; @(posedge clk);
            data_in = 32'h33333333; @(posedge clk);
            data_in = 32'h44444444; @(posedge clk);


            while(busy) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Maximum Length Packet (Length 15)", test_num);
            reset_dut();

            pkt_length = 4'd15;
            data_in = 32'hA0000000;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            for(i = 1; i < 15; i = i + 1) begin
                data_in = data_in + 1;
                @(posedge clk);
            end


            while(busy) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero Length Packet", test_num);
            reset_dut();

            pkt_length = 4'd0;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Start signal during Busy", test_num);
            reset_dut();


            pkt_length = 4'd4;
            data_in = 32'hAAAA_AAAA;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            @(posedge clk);
            data_in = 32'hBBBB_BBBB;
            pkt_length = 4'd8;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            while(busy) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_tx Testbench");
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
        input expected_busy;
        input [31:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,clk, data_in, pkt_length, rst_n, start, busy, data_out);
    end

endmodule
