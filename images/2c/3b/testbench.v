`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg [7:0] data_in_ch0;
    reg [7:0] data_in_ch1;
    reg read_en_ch0;
    reg read_en_ch1;
    reg reset;
    reg write_en;
    wire [7:0] data_out;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in_ch0(data_in_ch0),
        .data_in_ch1(data_in_ch1),
        .read_en_ch0(read_en_ch0),
        .read_en_ch1(read_en_ch1),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out),
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
            data_in_ch0 = 8'h00;
            data_in_ch1 = 8'h00;
            read_en_ch0 = 0;
            read_en_ch1 = 0;
            write_en = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful Transfer from Channel 0", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            data_in_ch0 = 8'hAA;
            read_en_ch0 = 1;
            write_en = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful Transfer from Channel 1", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 1;
            data_in_ch1 = 8'h55;
            read_en_ch1 = 1;
            write_en = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 0 Read Enable Missing", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            data_in_ch0 = 8'hFF;
            read_en_ch0 = 0;
            write_en = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Destination Write Enable Missing", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 1;
            data_in_ch1 = 8'hCC;
            read_en_ch1 = 1;
            write_en = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel Isolation (Select 0, valid data on 1)", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            data_in_ch0 = 8'h11;
            data_in_ch1 = 8'hEE;
            read_en_ch0 = 1;
            read_en_ch1 = 1;
            write_en = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Switching Channels", test_num);
            reset_dut();


            @(posedge clk);
            channel_select = 0;
            data_in_ch0 = 8'hA1;
            data_in_ch1 = 8'hB2;
            read_en_ch0 = 1;
            read_en_ch1 = 1;
            write_en = 1;

            @(posedge clk);
            #1;


            channel_select = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hB2, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_transfer_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_complete=%b",
                         expected_data_out, expected_transfer_complete);
                $display("  Got:      data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
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
        $dumpvars(0,channel_select, clk, data_in_ch0, data_in_ch1, read_en_ch0, read_en_ch1, reset, write_en, data_out, transfer_complete);
    end

endmodule
