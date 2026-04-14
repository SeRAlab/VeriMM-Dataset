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
    reg rgWriteEnable;
    wire [3:0] rayaddr;
    wire [31:0] raydata;
    wire [2:0] raywe;
    wire rgDone;
    wire [31:0] rgReadData;

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
        .rgWriteEnable(rgWriteEnable),
        .rayaddr(rayaddr),
        .raydata(raydata),
        .raywe(raywe),
        .rgDone(rgDone),
        .rgReadData(rgReadData)
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
        raygroup = 2'b00;
        raygroupid = 2'b00;
        raygroupwe = 0;
        rgAddr = 4'h0;
        rgAddrValid = 0;
        rgData = 32'h0;
        rgWE = 3'b000;
        rgWriteEnable = 0;
        @(posedge clk);
        #1;
        globalreset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;


        #1;



        check_outputs(4'h0, 32'h0, 3'b000, 1'b0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;


        rgAddr = 4'hA;
        rgData = 32'hDEADBEEF;
        rgWE = 3'b111;
        rgAddrValid = 1;
        rgWriteEnable = 1;
        enablenear = 1;

        @(posedge clk);
        #2;



        #1;




        check_outputs(4'hA, 32'hDEADBEEF, 3'b111, 1'b1, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;


        raygroup = 2'b10;
        raygroupwe = 1;
        rgAddr = 4'h5;
        rgData = 32'h12345678;
        rgWE = 3'b011;
        rgAddrValid = 1;
        rgWriteEnable = 1;

        @(posedge clk);
        #2;


        #1;



        check_outputs(4'h5, 32'h12345678, 3'b011, 1'b1, 32'h12345678);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;


        rgAddr = 4'hF;
        rgData = 32'hCAFEBABE;
        rgWE = 3'b111;
        rgAddrValid = 0;
        rgWriteEnable = 1;

        @(posedge clk);
        #2;


        #1;



        check_outputs(4'h0, 32'h0, 3'b000, 1'b0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;


        rgAddr = 4'h3;
        rgData = 32'h55AA55AA;
        rgAddrValid = 1;
        rgWriteEnable = 0;

        @(posedge clk);
        #2;


        #1;



        check_outputs(4'h3, 32'h0, 3'b000, 1'b1, 32'h55AA55AA);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        enablenear = 1;
        raygroupid = 2'b11;
        rgAddr = 4'h1;
        rgData = 32'h88889999;
        rgWE = 3'b101;
        rgAddrValid = 1;
        rgWriteEnable = 1;

        @(posedge clk);
        #2;

        #1;


        check_outputs(4'h1, 32'h88889999, 3'b101, 1'b1, 32'h88889999);
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
        input [3:0] expected_rayaddr;
        input [31:0] expected_raydata;
        input [2:0] expected_raywe;
        input expected_rgDone;
        input [31:0] expected_rgReadData;
        begin
            if (expected_rayaddr === (expected_rayaddr ^ rayaddr ^ expected_rayaddr) &&
                expected_raydata === (expected_raydata ^ raydata ^ expected_raydata) &&
                expected_raywe === (expected_raywe ^ raywe ^ expected_raywe) &&
                expected_rgDone === (expected_rgDone ^ rgDone ^ expected_rgDone) &&
                expected_rgReadData === (expected_rgReadData ^ rgReadData ^ expected_rgReadData)) begin
                $display("PASS");
                $display("  Outputs: rayaddr=%h, raydata=%h, raywe=%h, rgDone=%b, rgReadData=%h",
                         rayaddr, raydata, raywe, rgDone, rgReadData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rayaddr=%h, raydata=%h, raywe=%h, rgDone=%b, rgReadData=%h",
                         expected_rayaddr, expected_raydata, expected_raywe, expected_rgDone, expected_rgReadData);
                $display("  Got:      rayaddr=%h, raydata=%h, raywe=%h, rgDone=%b, rgReadData=%h",
                         rayaddr, raydata, raywe, rgDone, rgReadData);
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
        $dumpvars(0,clk, enablenear, globalreset, raygroup, raygroupid, raygroupwe, rgAddr, rgAddrValid, rgData, rgWE, rgWriteEnable, rayaddr, raydata, raywe, rgDone, rgReadData);
    end

endmodule
