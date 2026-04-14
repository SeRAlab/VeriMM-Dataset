`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg [7:0] data_in;
    reg request;
    reg reset;
    reg valid;
    wire [7:0] data_out1;
    wire [7:0] data_out2;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .request(request),
        .reset(reset),
        .valid(valid),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel_select = 0;
            data_in = 8'h00;
            request = 0;
            valid = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic transfer on Channel 0");
            test_num = 1;
            reset_dut();

            channel_select = 0;
            data_in = 8'hAA;
            valid = 1;
            request = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic transfer on Channel 1");
            test_num = 2;
            reset_dut();

            channel_select = 1;
            data_in = 8'h55;
            valid = 1;
            request = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Request high, Valid low (No Transfer)");
            test_num = 3;
            reset_dut();

            channel_select = 0;
            data_in = 8'hFF;
            valid = 0;
            request = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Valid high, Request low (No Transfer)");
            test_num = 4;
            reset_dut();

            channel_select = 1;
            data_in = 8'h12;
            valid = 1;
            request = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Output check during Reset");
            test_num = 5;


            channel_select = 0;
            data_in = 8'hEE;
            valid = 1;
            request = 1;
            reset = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00, 1'b0);
            reset = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Sequential transfers on different channels");
            test_num = 6;
            reset_dut();


            channel_select = 0;
            data_in = 8'h11;
            valid = 1;
            request = 1;
            @(posedge clk);
            #1;


            channel_select = 1;
            data_in = 8'h22;
            valid = 1;
            request = 1;
            @(posedge clk);
            #2;



            #1;




            check_outputs(8'h11, 8'h22, 1'b1);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        input expected_transfer_complete;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, transfer_complete=%b",
                         data_out1, data_out2, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, transfer_complete=%b",
                         expected_data_out1, expected_data_out2, expected_transfer_complete);
                $display("  Got:      data_out1=%h, data_out2=%h, transfer_complete=%b",
                         data_out1, data_out2, transfer_complete);
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
        $dumpvars(0,channel_select, clk, data_in, request, reset, valid, data_out1, data_out2, transfer_complete);
    end

endmodule
