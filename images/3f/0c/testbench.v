`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in_ch1;
    reg [7:0] data_in_ch2;
    reg req_ch1;
    reg req_ch2;
    reg rst;
    wire ack_ch1;
    wire ack_ch2;
    wire [7:0] data_out_ch1;
    wire [7:0] data_out_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in_ch1(data_in_ch1),
        .data_in_ch2(data_in_ch2),
        .req_ch1(req_ch1),
        .req_ch2(req_ch2),
        .rst(rst),
        .ack_ch1(ack_ch1),
        .ack_ch2(ack_ch2),
        .data_out_ch1(data_out_ch1),
        .data_out_ch2(data_out_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_ch1 = 0;
            req_ch2 = 0;
            data_in_ch1 = 0;
            data_in_ch2 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Single Transfer", test_num);
            reset_dut();

            @(posedge clk);
            data_in_ch1 = 8'hAA;
            req_ch1 = 1;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Single Transfer", test_num);
            reset_dut();

            @(posedge clk);
            data_in_ch2 = 8'h55;
            req_ch2 = 1;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 8'h00, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Dual Channel Transfer", test_num);
            reset_dut();

            @(posedge clk);
            data_in_ch1 = 8'h12;
            data_in_ch2 = 8'h34;
            req_ch1 = 1;
            req_ch2 = 1;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 8'h12, 8'h34);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State Verification", test_num);
            reset_dut();

            @(posedge clk);
            data_in_ch1 = 8'hFF;
            data_in_ch2 = 8'hEE;
            req_ch1 = 0;
            req_ch2 = 0;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Transfers on Channel 1", test_num);
            reset_dut();


            @(posedge clk);
            data_in_ch1 = 8'hA1;
            req_ch1 = 1;
            repeat(2) @(posedge clk);


            req_ch1 = 0;
            @(posedge clk);
            data_in_ch1 = 8'hB2;
            req_ch1 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 8'hB2, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Active Request", test_num);
            reset_dut();

            @(posedge clk);
            data_in_ch1 = 8'hCC;
            req_ch1 = 1;
            @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;


            #1;



            check_outputs(1'b0, 1'b0, 8'h00, 8'h00);
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
        input expected_ack_ch1;
        input expected_ack_ch2;
        input [7:0] expected_data_out_ch1;
        input [7:0] expected_data_out_ch2;
        begin
            if (expected_ack_ch1 === (expected_ack_ch1 ^ ack_ch1 ^ expected_ack_ch1) &&
                expected_ack_ch2 === (expected_ack_ch2 ^ ack_ch2 ^ expected_ack_ch2) &&
                expected_data_out_ch1 === (expected_data_out_ch1 ^ data_out_ch1 ^ expected_data_out_ch1) &&
                expected_data_out_ch2 === (expected_data_out_ch2 ^ data_out_ch2 ^ expected_data_out_ch2)) begin
                $display("PASS");
                $display("  Outputs: ack_ch1=%b, ack_ch2=%b, data_out_ch1=%h, data_out_ch2=%h",
                         ack_ch1, ack_ch2, data_out_ch1, data_out_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_ch1=%b, ack_ch2=%b, data_out_ch1=%h, data_out_ch2=%h",
                         expected_ack_ch1, expected_ack_ch2, expected_data_out_ch1, expected_data_out_ch2);
                $display("  Got:      ack_ch1=%b, ack_ch2=%b, data_out_ch1=%h, data_out_ch2=%h",
                         ack_ch1, ack_ch2, data_out_ch1, data_out_ch2);
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
        $dumpvars(0,clk, data_in_ch1, data_in_ch2, req_ch1, req_ch2, rst, ack_ch1, ack_ch2, data_out_ch1, data_out_ch2);
    end

endmodule
