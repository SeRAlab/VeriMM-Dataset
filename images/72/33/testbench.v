`timescale 1ns/1ps

module reg_file_4x4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] rd_addr1;
    reg [1:0] rd_addr2;
    reg rst;
    reg [1:0] wr_addr;
    reg [3:0] wr_data;
    reg wr_en;
    wire [3:0] rd_data1;
    wire [3:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_4x4 dut (
        .clk(clk),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .rst(rst),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr1 = 0;
            rd_addr2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            rd_addr1 = 2'b00;
            rd_addr2 = 2'b11;
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single write and read", test_num);
            reset_dut();

            wr_en = 1;
            wr_addr = 2'b01;
            wr_data = 4'hA;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_addr1 = 2'b01;
            rd_addr2 = 2'b00;
            #1;
            #1;

            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple writes", test_num);
            reset_dut();

            wr_en = 1; wr_addr = 2'b10; wr_data = 4'h5;
            @(posedge clk);
            #1;

            wr_en = 1; wr_addr = 2'b11; wr_data = 4'hF;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_addr1 = 2'b10;
            rd_addr2 = 2'b11;
            #1;
            #1;

            check_outputs(4'h5, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable check", test_num);
            reset_dut();
            wr_en = 0;
            wr_addr = 2'b01;
            wr_data = 4'h7;
            @(posedge clk);
            #1;
            rd_addr1 = 2'b01;
            rd_addr2 = 2'b01;
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting data", test_num);
            reset_dut();

            wr_en = 1; wr_addr = 2'b00; wr_data = 4'h1;
            @(posedge clk);
            #1;

            wr_en = 1; wr_addr = 2'b00; wr_data = 4'hE;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_addr1 = 2'b00;
            rd_addr2 = 2'b00;
            #1;
            #1;

            check_outputs(4'hE, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous read same addr", test_num);
            reset_dut();
            wr_en = 1; wr_addr = 2'b10; wr_data = 4'hB;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_addr1 = 2'b10;
            rd_addr2 = 2'b10;
            #1;
            #1;

            check_outputs(4'hB, 4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full File Sweep", test_num);
            reset_dut();

            wr_en = 1;
            wr_addr = 0; wr_data = 4'h1; @(posedge clk); #1;
            wr_addr = 1; wr_data = 4'h2; @(posedge clk); #1;
            wr_addr = 2; wr_data = 4'h4; @(posedge clk); #1;
            wr_addr = 3; wr_data = 4'h8; @(posedge clk); #1;
            wr_en = 0;


            rd_addr1 = 2'b01;
            rd_addr2 = 2'b11;
            #1;
            #1;

            check_outputs(4'h2, 4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_4x4 Testbench");
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
        input [3:0] expected_rd_data1;
        input [3:0] expected_rd_data2;
        begin
            if (expected_rd_data1 === (expected_rd_data1 ^ rd_data1 ^ expected_rd_data1) &&
                expected_rd_data2 === (expected_rd_data2 ^ rd_data2 ^ expected_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data1=%h, rd_data2=%h",
                         expected_rd_data1, expected_rd_data2);
                $display("  Got:      rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
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
        $dumpvars(0,clk, rd_addr1, rd_addr2, rst, wr_addr, wr_data, wr_en, rd_data1, rd_data2);
    end

endmodule
