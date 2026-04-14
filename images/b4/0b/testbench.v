`timescale 1ns/1ps

module regfile_32bit_16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] raddr1;
    reg [3:0] raddr2;
    reg rst;
    reg [3:0] waddr;
    reg [31:0] wdata;
    reg we;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    regfile_32bit_16 dut (
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
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            raddr1 = 4'h0;
            raddr2 = 4'hF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write and Read Port 1", test_num);
            reset_dut();
            we = 1;
            waddr = 4'h5;
            wdata = 32'hA5A5A5A5;
            @(posedge clk);
            #1 we = 0;
            raddr1 = 4'h5;
            raddr2 = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hA5A5A5A5, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dual Port Read", test_num);
            reset_dut();

            we = 1; waddr = 4'h1; wdata = 32'h11111111;
            @(posedge clk);

            we = 1; waddr = 4'h2; wdata = 32'h22222222;
            @(posedge clk);
            #1 we = 0;
            raddr1 = 4'h1;
            raddr2 = 4'h2;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();
            we = 0;
            waddr = 4'h8;
            wdata = 32'hFFFFFFFF;
            @(posedge clk);
            #1 raddr1 = 4'h8;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();

            we = 1; waddr = 4'hA; wdata = 32'h12345678;
            @(posedge clk);

            we = 1; waddr = 4'hA; wdata = 32'h87654321;
            @(posedge clk);
            #1 we = 0; raddr1 = 4'hA;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h87654321, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Dual Read Same Address", test_num);
            reset_dut();
            we = 1; waddr = 4'hC; wdata = 32'hBEEFBEEF;
            @(posedge clk);
            #1 we = 0; raddr1 = 4'hC; raddr2 = 4'hC;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hBEEFBEEF, 32'hBEEFBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary Address Test", test_num);
            reset_dut();

            we = 1; waddr = 4'h0; wdata = 32'hAAAAAAAA;
            @(posedge clk);

            we = 1; waddr = 4'hF; wdata = 32'h55555555;
            @(posedge clk);
            #1 we = 0; raddr1 = 4'h0; raddr2 = 4'hF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regfile_32bit_16 Testbench");
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
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
