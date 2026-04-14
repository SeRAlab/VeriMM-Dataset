`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr1;
    reg [3:0] addr2;
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg write_en1;
    reg write_en2;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .write_en1(write_en1),
        .write_en2(write_en2),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr1 <= 4'h0;
            addr2 <= 4'h0;
            data_in1 <= 8'h00;
            data_in2 <= 8'h00;
            write_en1 <= 1'b0;
            write_en2 <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Port 1 Write and Read", test_num);
            reset_dut();


            addr1 <= 4'h4;
            data_in1 <= 8'hA5;
            write_en1 <= 1'b1;
            @(posedge clk);


            write_en1 <= 1'b0;
            addr1 <= 4'h4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Port 2 Write and Read", test_num);
            reset_dut();


            addr2 <= 4'hC;
            data_in2 <= 8'h5A;
            write_en2 <= 1'b1;
            @(posedge clk);


            write_en2 <= 1'b0;
            addr2 <= 4'hC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Writes (P1->Addr1, P2->Addr2)", test_num);
            reset_dut();


            addr1 <= 4'h1; data_in1 <= 8'h11; write_en1 <= 1'b1;
            addr2 <= 4'h2; data_in2 <= 8'h22; write_en2 <= 1'b1;
            @(posedge clk);


            write_en1 <= 1'b0; write_en2 <= 1'b0;
            addr1 <= 4'h1; addr2 <= 4'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Concurrent Read from different locations", test_num);
            reset_dut();


            addr1 <= 4'h5; data_in1 <= 8'h55; write_en1 <= 1'b1;
            @(posedge clk);
            addr1 <= 4'h6; data_in1 <= 8'h66; write_en1 <= 1'b1;
            @(posedge clk);


            write_en1 <= 1'b0;
            addr1 <= 4'h5; addr2 <= 4'h6;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 8'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Cross-Port Verification (P1 writes, P2 reads)", test_num);
            reset_dut();


            addr1 <= 4'h8; data_in1 <= 8'h88; write_en1 <= 1'b1;
            @(posedge clk);


            write_en1 <= 1'b0;
            addr2 <= 4'h8;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h88);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Address 15 Test", test_num);
            reset_dut();


            addr1 <= 4'hF; data_in1 <= 8'hFF; write_en1 <= 1'b1;
            addr2 <= 4'h0; data_in2 <= 8'h00; write_en2 <= 1'b1;
            @(posedge clk);


            write_en1 <= 1'b0; write_en2 <= 1'b0;
            addr1 <= 4'hF; addr2 <= 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'h00);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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
        $dumpvars(0,addr1, addr2, clk, data_in1, data_in2, write_en1, write_en2, data_out1, data_out2);
    end

endmodule
