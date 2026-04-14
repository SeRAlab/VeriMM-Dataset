`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enablenear;
    reg globalreset;
    reg [1:0] raygroup;
    reg [1:0] raygroupid;
    reg raygroupwe;
    reg [3:0] rgAddr;
    reg rgAddrValid;
    reg [31:0] rgData;
    reg [2:0] rgWE;
    wire [3:0] rayaddr;
    wire [31:0] raydata;
    wire [2:0] raywe;
    wire rgDone;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enablenear(enablenear),
        .globalreset(globalreset),
        .raygroup(raygroup),
        .raygroupid(raygroupid),
        .raygroupwe(raygroupwe),
        .rgAddr(rgAddr),
        .rgAddrValid(rgAddrValid),
        .rgData(rgData),
        .rgWE(rgWE),
        .rayaddr(rayaddr),
        .raydata(raydata),
        .raywe(raywe),
        .rgDone(rgDone)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            globalreset = 1;
            enablenear = 0;
            raygroup = 0;
            raygroupid = 0;
            raygroupwe = 0;
            rgAddr = 0;
            rgAddrValid = 0;
            rgData = 0;
            rgWE = 0;
            @(posedge clk);
            #2 globalreset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 32'h0, 3'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            rgAddr = 4'hA;
            rgData = 32'hDEADBEEF;
            rgWE = 3'b101;
            rgAddrValid = 1;
            @(posedge clk);

            #1;


            check_outputs(4'hA, 32'hDEADBEEF, 3'b101, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            rgAddr = 4'hF;
            rgData = 32'hAAAA5555;
            rgWE = 3'b111;
            rgAddrValid = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h0, 32'h0, 3'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            raygroup = 2'b10;
            raygroupid = 2'b01;
            raygroupwe = 1;
            enablenear = 1;
            rgAddr = 4'h2;
            rgData = 32'hC0FFEE00;
            rgWE = 3'b010;
            rgAddrValid = 1;
            @(posedge clk);

            #1;


            check_outputs(4'h2, 32'hC0FFEE00, 3'b010, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);

            rgAddr = 4'h1; rgData = 32'h1; rgWE = 3'b001; rgAddrValid = 1;
            @(posedge clk);

            rgAddr = 4'h2; rgData = 32'h2; rgWE = 3'b010; rgAddrValid = 1;
            @(posedge clk);

            #1;


            check_outputs(4'h2, 32'h00000002, 3'b010, 1'b1);
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
        input [3:0] expected_rayaddr;
        input [31:0] expected_raydata;
        input [2:0] expected_raywe;
        input expected_rgDone;
        begin
            if (expected_rayaddr === (expected_rayaddr ^ rayaddr ^ expected_rayaddr) &&
                expected_raydata === (expected_raydata ^ raydata ^ expected_raydata) &&
                expected_raywe === (expected_raywe ^ raywe ^ expected_raywe) &&
                expected_rgDone === (expected_rgDone ^ rgDone ^ expected_rgDone)) begin
                $display("PASS");
                $display("  Outputs: rayaddr=%h, raydata=%h, raywe=%h, rgDone=%b",
                         rayaddr, raydata, raywe, rgDone);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rayaddr=%h, raydata=%h, raywe=%h, rgDone=%b",
                         expected_rayaddr, expected_raydata, expected_raywe, expected_rgDone);
                $display("  Got:      rayaddr=%h, raydata=%h, raywe=%h, rgDone=%b",
                         rayaddr, raydata, raywe, rgDone);
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
        $dumpvars(0,clk, enablenear, globalreset, raygroup, raygroupid, raygroupwe, rgAddr, rgAddrValid, rgData, rgWE, rayaddr, raydata, raywe, rgDone);
    end

endmodule
