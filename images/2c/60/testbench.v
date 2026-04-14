`timescale 1ns/1ps

module turbo_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] encoded_data;
    reg rst;
    wire [3:0] decoded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_decoder dut (
        .clk(clk),
        .encoded_data(encoded_data),
        .rst(rst),
        .decoded_data(decoded_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            encoded_data = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input 4'b0000", test_num);
            reset_dut();
            encoded_data = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input 4'b1111", test_num);
            reset_dut();
            encoded_data = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input 4'b1010", test_num);
            reset_dut();
            encoded_data = 4'b1010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input 4'b0101", test_num);
            reset_dut();
            encoded_data = 4'b0101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input 4'b0001", test_num);
            reset_dut();
            encoded_data = 4'b0001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input 4'b1110", test_num);
            reset_dut();
            encoded_data = 4'b1110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_decoder Testbench");
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
        input [3:0] expected_decoded_data;
        begin
            if (expected_decoded_data === (expected_decoded_data ^ decoded_data ^ expected_decoded_data)) begin
                $display("PASS");
                $display("  Outputs: decoded_data=%h",
                         decoded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_data=%h",
                         expected_decoded_data);
                $display("  Got:      decoded_data=%h",
                         decoded_data);
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
        $dumpvars(0,clk, encoded_data, rst, decoded_data);
    end

endmodule
