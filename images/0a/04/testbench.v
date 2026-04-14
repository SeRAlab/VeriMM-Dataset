`timescale 1ns/1ps

module data_integrity_checker_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_integrity_checker dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            checksum_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Data (Valid Checksum)", test_num);
            reset_dut();
            data_in = 8'h00;
            checksum_in = 4'hF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones Data (Valid Checksum)", test_num);
            reset_dut();
            data_in = 8'hFF;
            checksum_in = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 0x55 (Valid Checksum)", test_num);
            reset_dut();
            data_in = 8'h55;
            checksum_in = 4'h5;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 0x88 (Carry-around Valid Checksum)", test_num);
            reset_dut();
            data_in = 8'h88;
            checksum_in = 4'hE;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Incorrect Checksum Mismatch", test_num);
            reset_dut();
            data_in = 8'hA5;
            checksum_in = 4'h1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify reset initializes output", test_num);

            data_in = 8'h00;
            checksum_in = 4'hF;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 0xAA (Valid Checksum)", test_num);
            reset_dut();
            data_in = 8'hAA;
            checksum_in = 4'hA;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_integrity_checker Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_valid;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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
        $dumpvars(0,checksum_in, clk, data_in, reset, valid);
    end

endmodule
