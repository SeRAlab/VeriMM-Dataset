`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] img00;
    reg [8:0] img01;
    reg [8:0] img02;
    reg [8:0] img10;
    reg [8:0] img11;
    reg [8:0] img12;
    reg [8:0] img20;
    reg [8:0] img21;
    reg [8:0] img22;
    reg [8:0] kern00;
    reg [8:0] kern01;
    reg [8:0] kern02;
    reg [8:0] kern10;
    reg [8:0] kern11;
    reg [8:0] kern12;
    reg [8:0] kern20;
    reg [8:0] kern21;
    reg [8:0] kern22;
    wire [15:0] conv_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .img00(img00),
        .img01(img01),
        .img02(img02),
        .img10(img10),
        .img11(img11),
        .img12(img12),
        .img20(img20),
        .img21(img21),
        .img22(img22),
        .kern00(kern00),
        .kern01(kern01),
        .kern02(kern02),
        .kern10(kern10),
        .kern11(kern11),
        .kern12(kern12),
        .kern20(kern20),
        .kern21(kern21),
        .kern22(kern22),
        .conv_out(conv_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        img00 = 0; img01 = 0; img02 = 0;
        img10 = 0; img11 = 0; img12 = 0;
        img20 = 0; img21 = 0; img22 = 0;
        kern00 = 0; kern01 = 0; kern02 = 0;
        kern10 = 0; kern11 = 0; kern12 = 0;
        kern20 = 0; kern21 = 0; kern22 = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Identity Kernel (Center Pixel)", test_num);
        img00 = 9'h010; img01 = 9'h020; img02 = 9'h030;
        img10 = 9'h040; img11 = 9'h055; img12 = 9'h060;
        img20 = 9'h070; img21 = 9'h080; img22 = 9'h090;
        kern00 = 0; kern01 = 0; kern02 = 0;
        kern10 = 0; kern11 = 1; kern12 = 0;
        kern20 = 0; kern21 = 0; kern22 = 0;
        #1;

        check_outputs(16'h0055);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Uniform Small Values", test_num);
        img00 = 2; img01 = 2; img02 = 2;
        img10 = 2; img11 = 2; img12 = 2;
        img20 = 2; img21 = 2; img22 = 2;
        kern00 = 3; kern01 = 3; kern02 = 3;
        kern10 = 3; kern11 = 3; kern12 = 3;
        kern20 = 3; kern21 = 3; kern22 = 3;
        #1;

        check_outputs(16'h0036);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Incremental Image Sum", test_num);
        img00 = 1; img01 = 2; img02 = 3;
        img10 = 4; img11 = 5; img12 = 6;
        img20 = 7; img21 = 8; img22 = 9;
        kern00 = 1; kern01 = 1; kern02 = 1;
        kern10 = 1; kern11 = 1; kern12 = 1;
        kern20 = 1; kern21 = 1; kern22 = 1;
        #1;

        check_outputs(16'h002D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large Values (No Overflow)", test_num);
        img00 = 80; img01 = 80; img02 = 80;
        img10 = 80; img11 = 80; img12 = 80;
        img20 = 80; img21 = 80; img22 = 80;
        kern00 = 80; kern01 = 80; kern02 = 80;
        kern10 = 80; kern11 = 80; kern12 = 80;
        kern20 = 80; kern21 = 80; kern22 = 80;
        #1;

        check_outputs(16'hE100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Overflow Truncation", test_num);
        img00 = 100; img01 = 100; img02 = 100;
        img10 = 100; img11 = 100; img12 = 100;
        img20 = 100; img21 = 100; img22 = 100;
        kern00 = 73; kern01 = 73; kern02 = 73;
        kern10 = 73; kern11 = 73; kern12 = 73;
        kern20 = 73; kern21 = 73; kern22 = 73;
        #1;

        check_outputs(16'h00A4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
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
        input [15:0] expected_conv_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_conv_out === (expected_conv_out ^ conv_out ^ expected_conv_out)) begin
                $display("PASS");
                $display("  Outputs: conv_out=%h",
                         conv_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conv_out=%h",
                         expected_conv_out);
                $display("  Got:      conv_out=%h",
                         conv_out);
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
