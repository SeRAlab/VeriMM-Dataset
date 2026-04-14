`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic Write and Read", test_num);

        write_enable = 1; data_in = 4'h0; read_enable = 0; #10;


        write_enable = 1; data_in = 4'hA; read_enable = 0; #10;


        write_enable = 0; data_in = 4'h0; read_enable = 1; #10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Read Disable Check", test_num);

        write_enable = 1; data_in = 4'h0; read_enable = 0; #10;


        write_enable = 1; data_in = 4'h5; read_enable = 0; #10;


        write_enable = 0; data_in = 4'hF; read_enable = 0; #10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Simultaneous Write and Read", test_num);

        write_enable = 1; data_in = 4'h0; read_enable = 0; #10;


        write_enable = 1; read_enable = 1; data_in = 4'hC; #10;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Data Retention Check", test_num);

        write_enable = 1; data_in = 4'h0; read_enable = 0; #10;


        write_enable = 1; data_in = 4'h7; read_enable = 0; #10;


        write_enable = 0; data_in = 4'hE; read_enable = 1; #10;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Consecutive Writes", test_num);

        write_enable = 1; data_in = 4'h0; read_enable = 0; #10;


        write_enable = 1; data_in = 4'h1; #10;
        write_enable = 1; data_in = 4'h2; #10;
        write_enable = 1; data_in = 4'h3; #10;


        write_enable = 0; read_enable = 1; #10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Read Stability", test_num);

        write_enable = 1; data_in = 4'h0; read_enable = 0; #10;


        write_enable = 1; data_in = 4'hB; read_enable = 0; #10;


        write_enable = 0; read_enable = 1; data_in = 4'h0; #5;
        data_in = 4'hF; #5;
        data_in = 4'h5; #5;
        #1;

        check_outputs(4'hB);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
