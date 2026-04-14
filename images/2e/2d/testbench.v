`timescale 1ns/1ps

module png_compress_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [2:0] pixel_in;
    wire [2:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compress dut (
        .enable(enable),
        .pixel_in(pixel_in),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Bypass mode - input 000", test_num);
        enable = 0;
        pixel_in = 3'b000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Bypass mode - input 111", test_num);
        enable = 0;
        pixel_in = 3'b111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Bypass mode - input 101", test_num);
        enable = 0;
        pixel_in = 3'b101;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Compression mode - input 000 (Expected 111)", test_num);
        enable = 1;
        pixel_in = 3'b000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Compression mode - input 111 (Expected 000)", test_num);
        enable = 1;
        pixel_in = 3'b111;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Compression mode - input 101 (Expected 010)", test_num);
        enable = 1;
        pixel_in = 3'b101;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Compression mode - input 011 (Expected 100)", test_num);
        enable = 1;
        pixel_in = 3'b011;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Toggle Enable - input 110", test_num);

        enable = 1;
        pixel_in = 3'b110;
        #1;

        enable = 0;
        #1;

        check_outputs(3'b110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compress Testbench");
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
        input [2:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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
