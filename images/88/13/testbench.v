`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [31:0] plaintext_addr;
    reg [31:0] plaintext_data;
    reg rst_n;
    wire [31:0] ciphertext_addr;
    wire [31:0] ciphertext_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .plaintext_addr(plaintext_addr),
        .plaintext_data(plaintext_data),
        .rst_n(rst_n),
        .ciphertext_addr(ciphertext_addr),
        .ciphertext_data(ciphertext_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            plaintext_addr = 32'h0;
            plaintext_data = 32'h0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Basic Encryption Operation", test_num);
            reset_dut();

            @(negedge clk);
            en = 1;
            plaintext_addr = 32'hA5A5A5A5;
            plaintext_data = 32'h5A5A5A5A;


            repeat(10) @(posedge clk);



            #1;




            check_outputs(ciphertext_addr, ciphertext_data);
        end
        endtask

    task testcase003;

        reg [31:0] captured_addr;
        reg [31:0] captured_data;
        begin
            test_num = 3;
            $display("Running Testcase %0d: Enable Signal Control", test_num);
            reset_dut();


            @(negedge clk);
            en = 1;
            plaintext_addr = 32'h11112222;
            plaintext_data = 32'h33334444;
            repeat(10) @(posedge clk);

            captured_addr = ciphertext_addr;
            captured_data = ciphertext_data;


            @(negedge clk);
            en = 0;
            plaintext_addr = 32'hFFFFFFFF;
            plaintext_data = 32'hEEEEEEEE;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(captured_addr, captured_data);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Successive Encryption", test_num);
            reset_dut();


            @(negedge clk);
            en = 1;
            plaintext_addr = 32'h00000001;
            plaintext_data = 32'h10000000;
            repeat(10) @(posedge clk);


            @(negedge clk);
            en = 1;
            plaintext_addr = 32'h00000002;
            plaintext_data = 32'h20000000;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(ciphertext_addr, ciphertext_data);
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
        input [31:0] expected_ciphertext_addr;
        input [31:0] expected_ciphertext_data;
        begin
            if (expected_ciphertext_addr === (expected_ciphertext_addr ^ ciphertext_addr ^ expected_ciphertext_addr) &&
                expected_ciphertext_data === (expected_ciphertext_data ^ ciphertext_data ^ expected_ciphertext_data)) begin
                $display("PASS");
                $display("  Outputs: ciphertext_addr=%h, ciphertext_data=%h",
                         ciphertext_addr, ciphertext_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext_addr=%h, ciphertext_data=%h",
                         expected_ciphertext_addr, expected_ciphertext_data);
                $display("  Got:      ciphertext_addr=%h, ciphertext_data=%h",
                         ciphertext_addr, ciphertext_data);
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
        $dumpvars(0,clk, en, plaintext_addr, plaintext_data, rst_n, ciphertext_addr, ciphertext_data);
    end

endmodule
