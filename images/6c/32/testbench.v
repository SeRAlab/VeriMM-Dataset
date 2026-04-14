`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] raddr1;
    reg [1:0] raddr2;
    reg [1:0] waddr;
    reg [7:0] wdata;
    reg we;
    wire [7:0] rdata1;
    wire [7:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            we = 0;
            waddr = 0;
            wdata = 0;
            raddr1 = 0;
            raddr2 = 0;


            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                we = 1;
                waddr = i;
                wdata = 8'h00;
            end
            @(negedge clk);
            we = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Write and Read (Reg 0)", test_num);
            reset_dut();

            @(negedge clk);
            we = 1;
            waddr = 2'b00;
            wdata = 8'hA5;

            @(negedge clk);
            we = 0;
            raddr1 = 2'b00;
            raddr2 = 2'b00;

            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Write Enable (WE) Check", test_num);
            reset_dut();

            @(negedge clk);
            we = 0;
            waddr = 2'b01;
            wdata = 8'hFF;
            raddr1 = 2'b01;
            raddr2 = 2'b01;

            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Dual Port Read (Reg 1 and Reg 2)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            waddr = 2'b01;
            wdata = 8'h55;


            @(negedge clk);
            we = 1;
            waddr = 2'b10;
            wdata = 8'hAA;

            @(negedge clk);
            we = 0;
            raddr1 = 2'b01;
            raddr2 = 2'b10;

            #1;
            #1;

            check_outputs(8'h55, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Overwriting Data (Reg 3)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            waddr = 2'b11;
            wdata = 8'h11;


            @(negedge clk);
            we = 1;
            waddr = 2'b11;
            wdata = 8'h22;

            @(negedge clk);
            we = 0;
            raddr1 = 2'b11;
            raddr2 = 2'b11;

            #1;
            #1;

            check_outputs(8'h22, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Address Isolation (Reg 2 vs Reg 0)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            waddr = 2'b10;
            wdata = 8'hCC;

            @(negedge clk);
            we = 0;
            raddr1 = 2'b10;
            raddr2 = 2'b00;

            #1;
            #1;

            check_outputs(8'hCC, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file Testbench");
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
        input [7:0] expected_rdata1;
        input [7:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,clk, raddr1, raddr2, waddr, wdata, we, rdata1, rdata2);
    end

endmodule
