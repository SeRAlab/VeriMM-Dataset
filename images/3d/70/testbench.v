`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr_ch1;
    reg [7:0] dest_addr_ch2;
    reg enable_ch1;
    reg enable_ch2;
    reg rst;
    reg [7:0] src_addr_ch1;
    reg [7:0] src_addr_ch2;
    wire [7:0] data_out_ch1;
    wire [7:0] data_out_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr_ch1(dest_addr_ch1),
        .dest_addr_ch2(dest_addr_ch2),
        .enable_ch1(enable_ch1),
        .enable_ch2(enable_ch2),
        .rst(rst),
        .src_addr_ch1(src_addr_ch1),
        .src_addr_ch2(src_addr_ch2),
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
            enable_ch1 = 0;
            enable_ch2 = 0;
            src_addr_ch1 = 0;
            src_addr_ch2 = 0;
            dest_addr_ch1 = 0;
            dest_addr_ch2 = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            src_addr_ch1 = 8'hAA;
            src_addr_ch2 = 8'hBB;
            enable_ch1 = 0;
            enable_ch2 = 0;

            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Enable Transfer", test_num);
            reset_dut();

            @(negedge clk);
            src_addr_ch1 = 8'h11;
            dest_addr_ch1 = 8'hD1;
            enable_ch1 = 1;
            enable_ch2 = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Enable Transfer", test_num);
            reset_dut();

            @(negedge clk);
            src_addr_ch2 = 8'h22;
            dest_addr_ch2 = 8'hD2;
            enable_ch1 = 0;
            enable_ch2 = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dual Channel Transfer", test_num);
            reset_dut();

            @(negedge clk);
            src_addr_ch1 = 8'hA1;
            src_addr_ch2 = 8'hB2;
            enable_ch1 = 1;
            enable_ch2 = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA1, 8'hB2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Disable after transfer", test_num);
            reset_dut();


            @(negedge clk);
            src_addr_ch1 = 8'hFF;
            enable_ch1 = 1;
            @(posedge clk);


            @(negedge clk);
            enable_ch1 = 0;
            src_addr_ch1 = 8'hEE;

            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Address Update", test_num);
            reset_dut();

            @(negedge clk);
            enable_ch1 = 1;
            src_addr_ch1 = 8'h01;
            @(posedge clk);

            @(negedge clk);
            src_addr_ch1 = 8'h02;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h02, 8'h00);
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
        input [7:0] expected_data_out_ch1;
        input [7:0] expected_data_out_ch2;
        begin
            if (expected_data_out_ch1 === (expected_data_out_ch1 ^ data_out_ch1 ^ expected_data_out_ch1) &&
                expected_data_out_ch2 === (expected_data_out_ch2 ^ data_out_ch2 ^ expected_data_out_ch2)) begin
                $display("PASS");
                $display("  Outputs: data_out_ch1=%h, data_out_ch2=%h",
                         data_out_ch1, data_out_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_ch1=%h, data_out_ch2=%h",
                         expected_data_out_ch1, expected_data_out_ch2);
                $display("  Got:      data_out_ch1=%h, data_out_ch2=%h",
                         data_out_ch1, data_out_ch2);
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
        $dumpvars(0,clk, dest_addr_ch1, dest_addr_ch2, enable_ch1, enable_ch2, rst, src_addr_ch1, src_addr_ch2, data_out_ch1, data_out_ch2);
    end

endmodule
