`timescale 1ns/1ps

module sram_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] addr;
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_8bit dut (
        .addr(addr),
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read at Address 0", test_num);

        we = 0; re = 0; addr = 3'b000; data_in = 8'h00;
        #10;


        addr = 3'b000; data_in = 8'hAA; we = 1;
        #10;
        we = 0;


        re = 1;
        #10;
        #1;

        check_outputs(8'hAA);
        re = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Write and Read at Address 7", test_num);

        we = 0; re = 0; addr = 3'b000; data_in = 8'h00;
        #10;


        addr = 3'b111; data_in = 8'h55; we = 1;
        #10;
        we = 0;


        re = 1;
        #10;
        #1;

        check_outputs(8'h55);
        re = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Verify Write Inhibit when we=0", test_num);

        we = 0; re = 0; addr = 3'b010; data_in = 8'h00;
        #10;


        addr = 3'b010; data_in = 8'h11; we = 1;
        #10;
        we = 0;


        data_in = 8'hEE;
        #10;


        re = 1;
        #10;
        #1;

        check_outputs(8'h11);
        re = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Overwriting data", test_num);

        we = 0; re = 0; addr = 3'b100; data_in = 8'h00;
        #10;


        addr = 3'b100; data_in = 8'h12; we = 1;
        #10;

        data_in = 8'h34;
        #10;
        we = 0;


        re = 1;
        #10;
        #1;

        check_outputs(8'h34);
        re = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Address Independence Check", test_num);

        we = 0; re = 0; addr = 3'b000; data_in = 8'h00;
        #10;


        addr = 3'b001; data_in = 8'h11; we = 1;
        #10;

        addr = 3'b010; data_in = 8'h22; we = 1;
        #10;
        we = 0;


        addr = 3'b001; re = 1;
        #10;
        #1;

        check_outputs(8'h11);
        re = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Verify re signal behavior", test_num);

        we = 0; re = 0; addr = 3'b110; data_in = 8'h00;
        #10;


        addr = 3'b110; data_in = 8'hCC; we = 1;
        #10;
        we = 0;


        addr = 3'b110; re = 0;
        #10;



        re = 1;
        #10;
        #1;

        check_outputs(8'hCC);
        re = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_8bit Testbench");
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
        input [7:0] expected_data_out;
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
