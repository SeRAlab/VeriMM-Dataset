`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in_ch1;
    reg [7:0] data_in_ch2;
    reg enable_ch1;
    reg enable_ch2;
    reg reset;
    wire [7:0] data_out_ch1;
    wire [7:0] data_out_ch2;
    wire transfer_complete_ch1;
    wire transfer_complete_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in_ch1(data_in_ch1),
        .data_in_ch2(data_in_ch2),
        .enable_ch1(enable_ch1),
        .enable_ch2(enable_ch2),
        .reset(reset),
        .data_out_ch1(data_out_ch1),
        .data_out_ch2(data_out_ch2),
        .transfer_complete_ch1(transfer_complete_ch1),
        .transfer_complete_ch2(transfer_complete_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable_ch1 = 0;
            enable_ch2 = 0;
            data_in_ch1 = 8'h00;
            data_in_ch2 = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Channel 1 Enable Only", test_num);
            reset_dut();

            enable_ch1 = 1;
            data_in_ch1 = 8'hAA;
            enable_ch2 = 0;
            data_in_ch2 = 8'h55;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Channel 2 Enable Only", test_num);
            reset_dut();

            enable_ch1 = 0;
            data_in_ch1 = 8'hAA;
            enable_ch2 = 1;
            data_in_ch2 = 8'hBB;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hBB, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Both Channels Enabled", test_num);
            reset_dut();

            enable_ch1 = 1;
            data_in_ch1 = 8'h12;
            enable_ch2 = 1;
            data_in_ch2 = 8'h34;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h12, 8'h34, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Input Change with Disable", test_num);
            reset_dut();

            enable_ch1 = 0;
            enable_ch2 = 0;
            data_in_ch1 = 8'hFF;
            data_in_ch2 = 8'hEE;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Transfers", test_num);
            reset_dut();


            enable_ch1 = 1;
            data_in_ch1 = 8'h01;
            @(posedge clk);


            #1;
            data_in_ch1 = 8'h02;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Disable after Enable", test_num);
            reset_dut();

            enable_ch1 = 1;
            data_in_ch1 = 8'hCC;
            @(posedge clk);
            #1;

            enable_ch1 = 0;
            data_in_ch1 = 8'hDD;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00, 8'h00, 1'b0, 1'b0);
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
        input [7:0] expected_data_out_ch1;
        input [7:0] expected_data_out_ch2;
        input expected_transfer_complete_ch1;
        input expected_transfer_complete_ch2;
        begin
            if (expected_data_out_ch1 === (expected_data_out_ch1 ^ data_out_ch1 ^ expected_data_out_ch1) &&
                expected_data_out_ch2 === (expected_data_out_ch2 ^ data_out_ch2 ^ expected_data_out_ch2) &&
                expected_transfer_complete_ch1 === (expected_transfer_complete_ch1 ^ transfer_complete_ch1 ^ expected_transfer_complete_ch1) &&
                expected_transfer_complete_ch2 === (expected_transfer_complete_ch2 ^ transfer_complete_ch2 ^ expected_transfer_complete_ch2)) begin
                $display("PASS");
                $display("  Outputs: data_out_ch1=%h, data_out_ch2=%h, transfer_complete_ch1=%b, transfer_complete_ch2=%b",
                         data_out_ch1, data_out_ch2, transfer_complete_ch1, transfer_complete_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_ch1=%h, data_out_ch2=%h, transfer_complete_ch1=%b, transfer_complete_ch2=%b",
                         expected_data_out_ch1, expected_data_out_ch2, expected_transfer_complete_ch1, expected_transfer_complete_ch2);
                $display("  Got:      data_out_ch1=%h, data_out_ch2=%h, transfer_complete_ch1=%b, transfer_complete_ch2=%b",
                         data_out_ch1, data_out_ch2, transfer_complete_ch1, transfer_complete_ch2);
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
        $dumpvars(0,clk, data_in_ch1, data_in_ch2, enable_ch1, enable_ch2, reset, data_out_ch1, data_out_ch2, transfer_complete_ch1, transfer_complete_ch2);
    end

endmodule
