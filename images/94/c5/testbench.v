`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] raddr1;
    reg [1:0] raddr2;
    reg rst;
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
        .rst(rst),
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

        begin
            rst = 1;
            we = 0;
            waddr = 0;
            wdata = 0;
            raddr1 = 0;
            raddr2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            raddr1 = 2'b00;
            raddr2 = 2'b11;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Register Write/Read", test_num);
            reset_dut();

            @(posedge clk);
            we = 1;
            waddr = 2'b01;
            wdata = 8'hA5;
            @(posedge clk);
            we = 0;

            raddr1 = 2'b01;
            raddr2 = 2'b01;
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write All Registers", test_num);
            reset_dut();


            @(posedge clk);
            we = 1; waddr = 2'b00; wdata = 8'h11; @(posedge clk);
            we = 1; waddr = 2'b01; wdata = 8'h22; @(posedge clk);
            we = 1; waddr = 2'b10; wdata = 8'h33; @(posedge clk);
            we = 1; waddr = 2'b11; wdata = 8'h44; @(posedge clk);
            we = 0;

            raddr1 = 2'b10;
            raddr2 = 2'b11;
            #1;
            #1;

            check_outputs(8'h33, 8'h44);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();

            @(posedge clk);
            we = 0;
            waddr = 2'b10;
            wdata = 8'hFF;
            @(posedge clk);

            raddr1 = 2'b10;
            raddr2 = 2'b00;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Register", test_num);
            reset_dut();

            @(posedge clk);
            we = 1; waddr = 2'b00; wdata = 8'hAA; @(posedge clk);
            we = 1; waddr = 2'b00; wdata = 8'h55; @(posedge clk);
            we = 0;

            raddr1 = 2'b00;
            raddr2 = 2'b01;
            #1;
            #1;

            check_outputs(8'h55, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read Port Access", test_num);
            reset_dut();

            @(posedge clk);
            we = 1; waddr = 2'b00; wdata = 8'hDE; @(posedge clk);
            we = 1; waddr = 2'b11; wdata = 8'hAD; @(posedge clk);
            we = 0;

            raddr1 = 2'b00;
            raddr2 = 2'b11;
            #1;
            #1;

            check_outputs(8'hDE, 8'hAD);
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
        $dumpvars(0,clk, raddr1, raddr2, rst, waddr, wdata, we, rdata1, rdata2);
    end

endmodule
