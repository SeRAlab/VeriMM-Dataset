`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address_a;
    reg [7:0] address_b;
    reg clock;
    reg [31:0] data_a;
    reg [31:0] data_b;
    reg wren_a;
    reg wren_b;
    wire [31:0] q_a;
    wire [31:0] q_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_a(address_a),
        .address_b(address_b),
        .clock(clock),
        .data_a(data_a),
        .data_b(data_b),
        .wren_a(wren_a),
        .wren_b(wren_b),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address_a = 0;
            address_b = 0;
            data_a = 0;
            data_b = 0;
            wren_a = 0;
            wren_b = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write/Read Port A", test_num);
            reset_dut();


            wren_a = 1;
            address_a = 8'h10;
            data_a = 32'hDEADBEEF;
            @(posedge clock);
            #1;


            wren_a = 0;
            address_a = 8'h10;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write/Read Port B", test_num);
            reset_dut();


            wren_b = 1;
            address_b = 8'h20;
            data_b = 32'hCAFEBABE;
            @(posedge clock);
            #1;


            wren_b = 0;
            address_b = 8'h20;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h0, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Port A & B Writes", test_num);
            reset_dut();


            wren_a = 1;
            wren_b = 1;
            address_a = 8'h05;
            address_b = 8'h06;
            data_a = 32'h11112222;
            data_b = 32'h33334444;
            @(posedge clock);
            #1;


            wren_a = 0;
            wren_b = 0;
            address_a = 8'h05;
            address_b = 8'h06;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Port A, Read Port B (Sequential)", test_num);
            reset_dut();


            wren_a = 1;
            address_a = 8'h55;
            data_a = 32'h55AA55AA;
            @(posedge clock);
            #1;


            wren_a = 0;
            address_b = 8'h55;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0, 32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Addresses (0 and 255)", test_num);
            reset_dut();


            wren_a = 1;
            wren_b = 1;
            address_a = 8'h00;
            address_b = 8'hFF;
            data_a = 32'h00000001;
            data_b = 32'hFFFFFFFF;
            @(posedge clock);
            #1;


            wren_a = 0;
            wren_b = 0;
            address_a = 8'h00;
            address_b = 8'hFF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00000001, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read Same Address", test_num);
            reset_dut();


            wren_a = 1;
            address_a = 8'h88;
            data_a = 32'hABCDEF01;
            @(posedge clock);
            #1;


            wren_a = 0;
            address_a = 8'h88;
            address_b = 8'h88;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hABCDEF01, 32'hABCDEF01);
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
        input [31:0] expected_q_a;
        input [31:0] expected_q_b;
        begin
            if (expected_q_a === (expected_q_a ^ q_a ^ expected_q_a) &&
                expected_q_b === (expected_q_b ^ q_b ^ expected_q_b)) begin
                $display("PASS");
                $display("  Outputs: q_a=%h, q_b=%h",
                         q_a, q_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_a=%h, q_b=%h",
                         expected_q_a, expected_q_b);
                $display("  Got:      q_a=%h, q_b=%h",
                         q_a, q_b);
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
        $dumpvars(0,address_a, address_b, clock, data_a, data_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
