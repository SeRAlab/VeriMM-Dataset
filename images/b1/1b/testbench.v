`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] CS;
    reg Clk;
    reg [5:0] Mem_Addr;
    reg Mem_Write;
    reg [31:0] dina;
    wire [7:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CS(CS),
        .Clk(Clk),
        .Mem_Addr(Mem_Addr),
        .Mem_Write(Mem_Write),
        .dina(dina),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Mem_Addr = 0;
            CS = 0;
            Mem_Write = 0;
            dina = 0;
            @(posedge Clk);
            #2;
        end
        endtask
    task write_mem;

        input [5:0] addr;
        input [31:0] data;
        begin
            @(negedge Clk);
            Mem_Addr = addr;
            dina = data;
            Mem_Write = 1;
            @(posedge Clk);
            #2;
            Mem_Write = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0x11223344 to Addr 0, Read Byte 0", test_num);
            reset_dut();
            write_mem(6'h00, 32'h11223344);
            CS = 2'b00;
            Mem_Addr = 6'h00;
            #5;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0x11223344 to Addr 0, Read Byte 1", test_num);
            reset_dut();
            write_mem(6'h00, 32'h11223344);
            CS = 2'b01;
            Mem_Addr = 6'h00;
            #5;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0xAABBCCDD to Addr 1, Read Byte 2", test_num);
            reset_dut();
            write_mem(6'h01, 32'hAABBCCDD);
            CS = 2'b10;
            Mem_Addr = 6'h01;
            #5;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0xDEADBEEF to Addr 2, Read Byte 3", test_num);
            reset_dut();
            write_mem(6'h02, 32'hDEADBEEF);
            CS = 2'b11;
            Mem_Addr = 6'h02;
            #5;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0x55667788 to Addr 3, Read Byte 0", test_num);
            reset_dut();
            write_mem(6'h03, 32'h55667788);
            CS = 2'b00;
            Mem_Addr = 6'h03;
            #5;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Addr 0, then Addr 3, verify Addr 0 content", test_num);
            reset_dut();
            write_mem(6'h00, 32'h12345678);
            write_mem(6'h03, 32'hFFFFFFFF);
            CS = 2'b01;
            Mem_Addr = 6'h00;
            #5;
            #1;

            check_outputs(8'h56);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,CS, Clk, Mem_Addr, Mem_Write, dina, LED);
    end

endmodule
