`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg cmd;
    reg req;
    reg reset;
    reg [31:0] wdata;
    wire ack;
    wire [31:0] rdata_tr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cmd(cmd),
        .req(req),
        .reset(reset),
        .wdata(wdata),
        .ack(ack),
        .rdata_tr(rdata_tr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 0;
            addr = 0;
            cmd = 0;
            wdata = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write Operation", test_num);
            reset_dut();


            req = 1;
            cmd = 1;
            addr = 32'h00000004;
            wdata = 32'hABCD1234;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 32'hABCD1234);


            req = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Persistence and Read", test_num);
            reset_dut();


            req = 1; cmd = 1; addr = 32'h00000008; wdata = 32'h55AAFF00;
            @(posedge clk);
            #1;


            req = 0; cmd = 0; wdata = 32'h0;
            @(posedge clk);
            #1;


            req = 1;
            cmd = 0;
            addr = 32'h00000008;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'h55AAFF00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwriting Internal Register", test_num);
            reset_dut();


            req = 1; cmd = 1; addr = 32'h0; wdata = 32'h11111111;
            @(posedge clk);
            #1;


            req = 1; cmd = 1; addr = 32'h0; wdata = 32'h22222222;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'h22222222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset After Write", test_num);
            reset_dut();


            req = 1; cmd = 1; addr = 32'h000000F0; wdata = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Request (req=0)", test_num);
            reset_dut();


            req = 0;
            cmd = 1;
            addr = 32'h123;
            wdata = 32'h99887766;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'h00000000);
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
        input expected_ack;
        input [31:0] expected_rdata_tr;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_rdata_tr === (expected_rdata_tr ^ rdata_tr ^ expected_rdata_tr)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, rdata_tr=%h",
                         ack, rdata_tr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, rdata_tr=%h",
                         expected_ack, expected_rdata_tr);
                $display("  Got:      ack=%b, rdata_tr=%h",
                         ack, rdata_tr);
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
        $dumpvars(0,addr, clk, cmd, req, reset, wdata, ack, rdata_tr);
    end

endmodule
