`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 32'h0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [31:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: All Zeros", test_num);
            test_val = 32'h0000_0000;
            reset_dut();
            data_in = test_val;



            for (i = 31; i >= 0; i = i - 1) begin
                #1;
                if (i == 0) #1;
 check_outputs(test_val[i]);
                else if (serial_out !== test_val[i]) begin


                end
                @(posedge clk);
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [31:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: All Ones", test_num);
            test_val = 32'hFFFF_FFFF;
            reset_dut();
            data_in = test_val;

            for (i = 31; i >= 0; i = i - 1) begin
                #1;
                if (i == 0) #1;
 check_outputs(test_val[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [31:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Alternating Bits (1010...)", test_num);
            test_val = 32'hAAAA_AAAA;
            reset_dut();
            data_in = test_val;

            for (i = 31; i >= 0; i = i - 1) begin
                #1;

                if (i == 0) #1;
 check_outputs(test_val[0]);
                else if (serial_out !== test_val[i]) begin
                    $display("Mismatch at bit %0d: Expected %b, Got %b", i, test_val[i], serial_out);
                end
                @(posedge clk);
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [31:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Walking One (MSB)", test_num);
            test_val = 32'h8000_0000;
            reset_dut();
            data_in = test_val;

            for (i = 31; i >= 0; i = i - 1) begin
                #1;
                if (i == 0) #1;
 check_outputs(test_val[0]);
                @(posedge clk);
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [31:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Pattern 0x12345678", test_num);
            test_val = 32'h1234_5678;
            reset_dut();
            data_in = test_val;

            for (i = 31; i >= 0; i = i - 1) begin
                #1;

                if (i == 0) #1;
 check_outputs(test_val[0]);
                else if (serial_out !== test_val[i]) begin

                end
                @(posedge clk);
            end
        end
        endtask

    task testcase006;

        integer i;
        reg [31:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Pattern 0xDEADBEEF", test_num);
            test_val = 32'hDEAD_BEEF;
            reset_dut();
            data_in = test_val;

            for (i = 31; i >= 0; i = i - 1) begin
                #1;
                if (i == 0) #1;
 check_outputs(test_val[0]);
                @(posedge clk);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data_in, rst, serial_out);
    end

endmodule
