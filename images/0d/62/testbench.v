`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg clk;
    reg rst;
    reg start;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            addr1 = 8'h00;
            addr2 = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Transfer", test_num);
            reset_dut();


            addr1 = 8'h10;
            addr2 = 8'h20;


            start = 1;
            @(posedge clk);
            #1 start = 0;


            @(posedge clk);
            #2;



            #1;




            check_outputs(8'h10, 8'h20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Address Boundary", test_num);
            reset_dut();

            addr1 = 8'h00;
            addr2 = 8'h00;

            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Address Boundary", test_num);
            reset_dut();

            addr1 = 8'hFF;
            addr2 = 8'hFF;

            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Patterned Bit Addresses", test_num);
            reset_dut();

            addr1 = 8'hAA;
            addr2 = 8'h55;

            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Values", test_num);
            reset_dut();

            addr1 = 8'h3C;
            addr2 = 8'hA5;

            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h3C, 8'hA5);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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
        $dumpvars(0,addr1, addr2, clk, rst, start, data_out1, data_out2);
    end

endmodule
