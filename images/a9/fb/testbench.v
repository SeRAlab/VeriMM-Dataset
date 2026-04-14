`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ALUResult;
    reg MemtoReg;
    reg RegWrite;
    reg clock;
    reg [15:0] data;
    reg [2:0] des;
    reg [4:0] phasecounter;
    reg reset;
    wire [15:0] out_ALUResult;
    wire out_MemtoReg;
    wire out_RegWrite;
    wire [15:0] out_data;
    wire [2:0] out_des;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResult(ALUResult),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .clock(clock),
        .data(data),
        .des(des),
        .phasecounter(phasecounter),
        .reset(reset),
        .out_ALUResult(out_ALUResult),
        .out_MemtoReg(out_MemtoReg),
        .out_RegWrite(out_RegWrite),
        .out_data(out_data),
        .out_des(out_des)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ALUResult = 0;
            MemtoReg = 0;
            RegWrite = 0;
            data = 0;
            des = 0;
            phasecounter = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0, 1'b0, 16'h0000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Data Propagation", test_num);
            reset_dut();

            @(negedge clock);
            ALUResult = 16'hABCD;
            MemtoReg = 1;
            RegWrite = 1;
            data = 16'h1234;
            des = 3'b101;
            phasecounter = 5'h0A;

            @(posedge clock);
            #2;
            #1;

            check_outputs(16'hABCD, 1'b1, 1'b1, 16'h1234, 3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data Stability", test_num);
            reset_dut();


            @(negedge clock);
            ALUResult = 16'h5555;
            MemtoReg = 0;
            RegWrite = 1;
            data = 16'hAAAA;
            des = 3'b011;

            @(posedge clock);
            #2;


            @(negedge clock);
            ALUResult = 16'hFFFF;
            data = 16'h0000;
            #1;
            #1;

            check_outputs(16'h5555, 1'b0, 1'b1, 16'hAAAA, 3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Control Signal Variations", test_num);
            reset_dut();

            @(negedge clock);
            ALUResult = 16'h1111;
            MemtoReg = 1;
            RegWrite = 0;
            data = 16'h2222;
            des = 3'b111;

            @(posedge clock);
            #2;
            #1;

            check_outputs(16'h1111, 1'b1, 1'b0, 16'h2222, 3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Asynchronous Reset During Operation", test_num);
            reset_dut();


            @(negedge clock);
            ALUResult = 16'h9999;
            MemtoReg = 1;
            RegWrite = 1;
            data = 16'h8888;
            des = 3'b010;

            @(posedge clock);
            #2;

            if (out_ALUResult == 16'h9999) begin

                #3;
                reset = 1;
                #1;

                #1;


                check_outputs(16'h0000, 1'b0, 1'b0, 16'h0000, 3'b000);
                reset = 0;
            end else begin
                $display("Setup for testcase 5 failed.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Updates", test_num);
            reset_dut();


            @(negedge clock);
            ALUResult = 16'h1010; des = 3'b001;
            @(posedge clock);


            @(negedge clock);
            ALUResult = 16'h2020; des = 3'b010;
            @(posedge clock);


            @(negedge clock);
            ALUResult = 16'h3030; des = 3'b011;
            @(posedge clock);

            #2;
            #1;

            check_outputs(16'h3030, 1'b0, 1'b0, 16'h0000, 3'b011);
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
        input [15:0] expected_out_ALUResult;
        input expected_out_MemtoReg;
        input expected_out_RegWrite;
        input [15:0] expected_out_data;
        input [2:0] expected_out_des;
        begin
            if (expected_out_ALUResult === (expected_out_ALUResult ^ out_ALUResult ^ expected_out_ALUResult) &&
                expected_out_MemtoReg === (expected_out_MemtoReg ^ out_MemtoReg ^ expected_out_MemtoReg) &&
                expected_out_RegWrite === (expected_out_RegWrite ^ out_RegWrite ^ expected_out_RegWrite) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_des === (expected_out_des ^ out_des ^ expected_out_des)) begin
                $display("PASS");
                $display("  Outputs: out_ALUResult=%h, out_MemtoReg=%b, out_RegWrite=%b, out_data=%h, out_des=%h",
                         out_ALUResult, out_MemtoReg, out_RegWrite, out_data, out_des);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_ALUResult=%h, out_MemtoReg=%b, out_RegWrite=%b, out_data=%h, out_des=%h",
                         expected_out_ALUResult, expected_out_MemtoReg, expected_out_RegWrite, expected_out_data, expected_out_des);
                $display("  Got:      out_ALUResult=%h, out_MemtoReg=%b, out_RegWrite=%b, out_data=%h, out_des=%h",
                         out_ALUResult, out_MemtoReg, out_RegWrite, out_data, out_des);
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
        $dumpvars(0,ALUResult, MemtoReg, RegWrite, clock, data, des, phasecounter, reset, out_ALUResult, out_MemtoReg, out_RegWrite, out_data, out_des);
    end

endmodule
