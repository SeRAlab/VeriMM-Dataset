`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] raddr;
    reg [4:0] waddr;
    reg [31:0] wdata;
    wire [31:0] rdata;
    wire wen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
        .wdata(wdata),
        .rdata(rdata),
        .wen(wen)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            waddr <= 5'b0;
            raddr <= 5'b0;
            wdata <= 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Write/Read (Addr 1)", test_num);


            waddr <= 5'd1;
            wdata <= 32'hDEADBEEF;
            @(posedge clk);
            #1;


            raddr <= 5'd1;
            waddr <= 5'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write/Read Max Index (Addr 7)", test_num);

            waddr <= 5'd7;
            wdata <= 32'hCAFEBABE;
            @(posedge clk);
            #1;

            raddr <= 5'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCAFEBABE, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Overwrite Value (Addr 2)", test_num);


            waddr <= 5'd2;
            wdata <= 32'h11112222;
            @(posedge clk);
            #1;


            waddr <= 5'd2;
            wdata <= 32'h33334444;
            @(posedge clk);
            #1;

            raddr <= 5'd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h33334444, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address Isolation (Addr 3 vs 4)", test_num);


            waddr <= 5'd3;
            wdata <= 32'hAAAA_AAAA;
            @(posedge clk);
            #1;


            waddr <= 5'd4;
            wdata <= 32'hBBBB_BBBB;
            @(posedge clk);
            #1;


            raddr <= 5'd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAA_AAAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Boundary Check (Addr 0)", test_num);

            waddr <= 5'd0;
            wdata <= 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            raddr <= 5'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1);
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
        input [31:0] expected_rdata;
        input expected_wen;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata) &&
                expected_wen === (expected_wen ^ wen ^ expected_wen)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h, wen=%b",
                         rdata, wen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h, wen=%b",
                         expected_rdata, expected_wen);
                $display("  Got:      rdata=%h, wen=%b",
                         rdata, wen);
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
        $dumpvars(0,clk, raddr, waddr, wdata, rdata, wen);
    end

endmodule
