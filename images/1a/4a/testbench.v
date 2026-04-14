`timescale 1ns/1ps

module aes_simple_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [3:0] key;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_simple_encryption dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in <= 4'b0000;
            key <= 4'b0000;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'h0;
            key     <= 4'h0;
            @(posedge clk); #2;
            $display("Testcase %0d: Zero data, zero key (0^0=0, Rot=0)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'hF;
            key     <= 4'h0;
            @(posedge clk); #2;
            $display("Testcase %0d: F data, 0 key (F^0=F, Rot=F)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'h1;
            key     <= 4'h0;
            @(posedge clk); #2;
            $display("Testcase %0d: 1 data, 0 key (1^0=1, Rot=2)", test_num);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'h8;
            key     <= 4'h0;
            @(posedge clk); #2;
            $display("Testcase %0d: 8 data, 0 key (8^0=8, Rot=1)", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'hA;
            key     <= 4'h5;
            @(posedge clk); #2;
            $display("Testcase %0d: A data, 5 key (A^5=F, Rot=F)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'hC;
            key     <= 4'hC;
            @(posedge clk); #2;
            $display("Testcase %0d: C data, C key (C^C=0, Rot=0)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'h3;
            key     <= 4'h1;
            @(posedge clk); #2;
            $display("Testcase %0d: 3 data, 1 key (3^1=2, Rot=4)", test_num);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in <= 4'h7;
            key     <= 4'h0;
            @(posedge clk); #2;
            $display("Testcase %0d: 7 data, 0 key (7^0=7, Rot=E)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_simple_encryption Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, key, data_out);
    end

endmodule
