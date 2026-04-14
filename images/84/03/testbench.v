`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] raddr1;
    reg [2:0] raddr2;
    reg [2:0] waddr;
    reg [15:0] wdata;
    reg we;
    wire [15:0] rdata1;
    wire [15:0] rdata2;

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
            @(negedge clk);
            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                waddr = i;
                wdata = 16'h0000;
                @(negedge clk);
            end
            we = 0;
            waddr = 0;
            wdata = 0;
            raddr1 = 0;
            raddr2 = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Basic Write and Dual Read", test_num);

            @(negedge clk);
            we = 1;
            waddr = 3'd1;
            wdata = 16'hABCD;
            @(negedge clk);
            we = 0;

            raddr1 = 3'd1;
            raddr2 = 3'd1;
            #1;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Multiple Register Write and Simultaneous Read", test_num);


            @(negedge clk);
            we = 1;
            waddr = 3'd2;
            wdata = 16'h1234;
            @(negedge clk);


            waddr = 3'd5;
            wdata = 16'h5678;
            @(negedge clk);
            we = 0;


            raddr1 = 3'd2;
            raddr2 = 3'd5;
            #1;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Write Enable (we) Check", test_num);

            @(negedge clk);
            we = 0;
            waddr = 3'd3;
            wdata = 16'hDEAD;
            @(negedge clk);

            raddr1 = 3'd3;
            raddr2 = 3'd0;
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Boundary Addresses (Reg 0 and 7)", test_num);

            @(negedge clk);
            we = 1;
            waddr = 3'd0;
            wdata = 16'hF00F;
            @(negedge clk);
            waddr = 3'd7;
            wdata = 16'h0FF0;
            @(negedge clk);
            we = 0;

            raddr1 = 3'd0;
            raddr2 = 3'd7;
            #1;
            #1;

            check_outputs(16'hF00F, 16'h0FF0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Overwriting Data", test_num);

            @(negedge clk);
            we = 1;
            waddr = 3'd4;
            wdata = 16'hAAAA;
            @(negedge clk);
            wdata = 16'h5555;
            @(negedge clk);
            we = 0;

            raddr1 = 3'd4;
            raddr2 = 3'd4;
            #1;
            #1;

            check_outputs(16'h5555, 16'h5555);
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
        input [15:0] expected_rdata1;
        input [15:0] expected_rdata2;
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
