`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [15:0] data_in;
    reg enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_16bit dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Address 0)", test_num);
            reset_dut();


            @(negedge clk);
            address = 4'h0;
            data_in = 16'hAAAA;
            enable = 1;
            @(negedge clk);
            enable = 0;


            @(negedge clk);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Write and Read (Address 15)", test_num);
            reset_dut();


            @(negedge clk);
            address = 4'hF;
            data_in = 16'h5555;
            enable = 1;
            @(negedge clk);
            enable = 0;


            @(negedge clk);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation Test", test_num);
            reset_dut();


            @(negedge clk);
            address = 4'h4;
            data_in = 16'h1111;
            enable = 1;
            @(negedge clk);


            address = 4'h5;
            data_in = 16'h2222;
            enable = 1;
            @(negedge clk);
            enable = 0;


            address = 4'h4;
            @(negedge clk);
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Signal Verification", test_num);
            reset_dut();


            @(negedge clk);
            address = 4'hA;
            data_in = 16'hBEEF;
            enable = 1;
            @(negedge clk);


            address = 4'hA;
            data_in = 16'hDEAD;
            enable = 0;
            @(negedge clk);


            address = 4'hA;
            @(negedge clk);
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Pattern Test (All 1s)", test_num);
            reset_dut();

            @(negedge clk);
            address = 4'h7;
            data_in = 16'hFFFF;
            enable = 1;
            @(negedge clk);
            enable = 0;

            @(negedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Write sequence", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            address = 4'h1; data_in = 16'h0001; @(negedge clk);
            address = 4'h2; data_in = 16'h0002; @(negedge clk);
            address = 4'h3; data_in = 16'h0003; @(negedge clk);
            enable = 0;


            address = 4'h3;
            @(negedge clk);
            #1;

            check_outputs(16'h0003);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, clk, data_in, enable, data_out);
    end

endmodule
