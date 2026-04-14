`timescale 1ns/1ps

module regfile_16bit_4regs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] rd_addr;
    reg rst;
    reg [1:0] wr_addr;
    reg [15:0] wr_data;
    reg wr_en;
    wire [15:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    regfile_16bit_4regs dut (
        .clk(clk),
        .rd_addr(rd_addr),
        .rst(rst),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            wr_en = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr = 0;
            @(posedge clk);
            rst = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();
            rd_addr = 2'b10;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write/Read (Reg 1)", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1;
            wr_addr = 2'b01;
            wr_data = 16'hA5A5;
            @(posedge clk);
            wr_en = 0;
            rd_addr = 2'b01;
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Writes", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1; wr_addr = 2'b00; wr_data = 16'h1111; @(posedge clk);
            wr_en = 1; wr_addr = 2'b01; wr_data = 16'h2222; @(posedge clk);
            wr_en = 1; wr_addr = 2'b10; wr_data = 16'h3333; @(posedge clk);
            wr_en = 1; wr_addr = 2'b11; wr_data = 16'h4444; @(posedge clk);
            wr_en = 0;
            rd_addr = 2'b11;
            #1;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable False", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 0;
            wr_addr = 2'b10;
            wr_data = 16'hFFFF;
            @(posedge clk);
            rd_addr = 2'b10;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Register", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1; wr_addr = 2'b00; wr_data = 16'hBEEF; @(posedge clk);
            wr_en = 1; wr_addr = 2'b00; wr_data = 16'hDEAD; @(posedge clk);
            wr_en = 0;
            rd_addr = 2'b00;
            #1;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset after write", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1; wr_addr = 2'b11; wr_data = 16'h1234; @(posedge clk);
            rst = 1; @(posedge clk);
            rst = 0;
            rd_addr = 2'b11;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regfile_16bit_4regs Testbench");
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
        input [15:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,clk, rd_addr, rst, wr_addr, wr_data, wr_en, rd_data);
    end

endmodule
