`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] req;
    reg rst;
    wire [3:0] ack;
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
        .ack(ack),
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
            req = 4'b0000;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            req = 4'b0001;
            data_in = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            req = 4'b1000;
            data_in = 8'hBB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000, 8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            req = 4'b0011;
            data_in = 8'hCC;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            req = 4'b1010;
            data_in = 8'hDD;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0010, 8'hDD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            req = 4'b1111;
            data_in = 8'hEE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001, 8'hEE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            req = 4'b0100;
            data_in = 8'h55;
            @(posedge clk);
            #2;

            req = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000, 8'h00);
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
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%h, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, req, rst, ack, data_out);
    end

endmodule
