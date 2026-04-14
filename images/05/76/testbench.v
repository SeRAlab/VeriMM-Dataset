`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [31:0] data_in;
    reg enable;
    wire [31:0] data_out;
    wire ready;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out),
        .ready(ready),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            address = 32'h0;
            data_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Idle State Check", test_num);


            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Basic Transaction", test_num);

            address = 32'hA000_1234;
            data_in = 32'hDEAD_BEEF;
            enable = 1;

            @(posedge clk);
            #1;



            #1;




            check_outputs(32'hDEAD_BEEF, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Pattern Transaction", test_num);

            address = 32'hC000_0000;
            data_in = 32'h55AA_55AA;
            enable = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55AA_55AA, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Zero Value Transaction", test_num);

            address = 32'h0000_0000;
            data_in = 32'h0000_0000;
            enable = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Max Value Transaction", test_num);

            address = 32'hFFFF_FFFF;
            data_in = 32'hFFFF_FFFF;
            enable = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Enable De-assertion", test_num);


            address = 32'h1122_3344;
            data_in = 32'h9988_7766;
            enable = 1;
            @(posedge clk);


            enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_ready;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b, valid=%b",
                         data_out, ready, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b, valid=%b",
                         expected_data_out, expected_ready, expected_valid);
                $display("  Got:      data_out=%h, ready=%b, valid=%b",
                         data_out, ready, valid);
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
        $dumpvars(0,address, clk, data_in, enable, data_out, ready, valid);
    end

endmodule
