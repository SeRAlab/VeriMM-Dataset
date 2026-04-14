`timescale 1ns/1ps

module png_compression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    wire [3:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compression dut (
        .pixel_in(pixel_in),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All zeros", test_num);
        pixel_in = 8'h00;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: All ones", test_num);
        pixel_in = 8'hFF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Balanced nibbles (0xAA)", test_num);
        pixel_in = 8'hAA;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: High nibble only", test_num);
        pixel_in = 8'hF0;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Low nibble only", test_num);
        pixel_in = 8'h0F;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Small even sum (0x13)", test_num);
        pixel_in = 8'h13;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Small odd sum (0x45)", test_num);
        pixel_in = 8'h45;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Large odd sum (0xEF)", test_num);
        pixel_in = 8'hEF;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Midpoint values (0x88)", test_num);
        pixel_in = 8'h88;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Alternating bits (0x5A)", test_num);
        pixel_in = 8'h5A;
        #1;

        check_outputs(4'h7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_pixel_out;
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
